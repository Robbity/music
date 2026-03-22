require "test_helper"
require "stringio"

class SongTest < ActiveSupport::TestCase
  test "requires title" do
    song = Song.new(user: users(:one))
    attach_audio(song)

    refute song.valid?
    assert_includes song.errors[:title], "can't be blank"
  end

  test "requires audio file" do
    song = Song.new(title: "Test song", user: users(:one))

    refute song.valid?
    assert_includes song.errors[:audio_file], "can't be blank"
  end

  test "accepts supported audio types" do
    song = Song.new(title: "Test song", user: users(:one))
    attach_audio(song, content_type: "audio/mpeg")

    assert song.valid?
  end

  test "rejects unsupported audio types" do
    song = Song.new(title: "Test song", user: users(:one))
    attach_audio(song, content_type: "text/plain")

    refute song.valid?
    assert_includes song.errors[:audio_file], "must be a MP3 or WAV"
  end

  test "rejects unsupported artwork types" do
    song = Song.new(title: "Test song", user: users(:one))
    attach_audio(song)
    attach_artwork(song, content_type: "image/gif")

    refute song.valid?
    assert_includes song.errors[:artwork], "must be a JPEG or PNG"
  end

  test "sets artwork color on create" do
    song = Song.new(title: "Test song", user: users(:one))
    attach_audio(song)

    song.valid?
    assert song.artwork_color.present?
  end

  private
    def attach_audio(song, content_type: "audio/mpeg")
      song.audio_file.attach(
        io: StringIO.new("audio"),
        filename: "test.mp3",
        content_type: content_type
      )
    end

    def attach_artwork(song, content_type: "image/png")
      song.artwork.attach(
        io: StringIO.new("image"),
        filename: "test.png",
        content_type: content_type
      )
    end
end
