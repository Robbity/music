require "open3"
require "tempfile"

class NormalizeAudioJob < ApplicationJob
  queue_as :default

  TARGET_LUFS = -14
  TARGET_TP = -1.5
  TARGET_LRA = 11

  def perform(song_id)
    return if Rails.env.test?

    song = Song.find_by(id: song_id)
    return unless song&.audio_file&.attached?

    blob = song.audio_file.blob
    return if blob.metadata["normalized_lufs"].present?
    return unless ffmpeg_available?

    input = Tempfile.new([ "audio-input", file_extension(blob) ])
    input.binmode
    input.write(blob.download)
    input.flush

    output = Tempfile.new([ "audio-normalized", file_extension(blob) ])
    output.binmode
    output.close

    command = [
      "ffmpeg",
      "-y",
      "-i",
      input.path,
      "-af",
      loudnorm_filter,
      *codec_args(blob),
      output.path
    ]

    _stdout, stderr, status = Open3.capture3(*command)
    unless status.success?
      Rails.logger.warn("Audio normalization failed for song #{song_id}: #{stderr}")
      return
    end

    song.audio_file.attach(
      io: File.open(output.path),
      filename: normalized_filename(blob),
      content_type: output_content_type(blob)
    )

    song.audio_file.blob.update!(
      metadata: blob.metadata.merge(
        "normalized_lufs" => TARGET_LUFS,
        "normalized_at" => Time.current.iso8601
      )
    )

    blob.purge
  ensure
    input&.close!
    output&.close!
  end

  private
    def loudnorm_filter
      "loudnorm=I=#{TARGET_LUFS}:TP=#{TARGET_TP}:LRA=#{TARGET_LRA}"
    end

    def ffmpeg_available?
      system("ffmpeg -version > /dev/null 2>&1")
    end

    def output_content_type(blob)
      case blob.content_type
      when "audio/mpeg", "audio/mp3"
        "audio/mpeg"
      when "audio/wav", "audio/x-wav", "audio/wave", "audio/vnd.wave"
        "audio/wav"
      else
        blob.content_type
      end
    end

    def file_extension(blob)
      case output_content_type(blob)
      when "audio/mpeg"
        ".mp3"
      when "audio/wav"
        ".wav"
      else
        ".audio"
      end
    end

    def codec_args(blob)
      case output_content_type(blob)
      when "audio/mpeg"
        [ "-c:a", "libmp3lame", "-b:a", "192k" ]
      when "audio/wav"
        [ "-c:a", "pcm_s16le" ]
      else
        []
      end
    end

    def normalized_filename(blob)
      "#{blob.filename.base}_normalized#{file_extension(blob)}"
    end
end
