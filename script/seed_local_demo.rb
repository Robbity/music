def make_silent_wav(seconds: 1, sample_rate: 44_100)
  samples = sample_rate * seconds
  data = "\x00\x00" * samples
  riff_size = 36 + data.bytesize

  header = "RIFF" + [ riff_size ].pack("V") + "WAVE"
  fmt = "fmt " + [ 16, 1, 1, sample_rate, sample_rate * 2, 2, 16 ].pack("VvvVVvv")
  data_chunk = "data" + [ data.bytesize ].pack("V")

  temp = Tempfile.new([ "silent", ".wav" ])
  temp.binmode
  temp.write(header + fmt + data_chunk + data)
  temp.flush
  temp.rewind
  temp
end

def find_or_create_user(email, username, password)
  User.find_or_create_by!(email: email) do |user|
    user.username = username
    user.password = password
    user.password_confirmation = password
  end
end

def find_or_create_song(user, title)
  song = user.songs.find_or_initialize_by(title: title)
  return song if song.persisted?

  wav = make_silent_wav
  song.audio_file.attach(io: wav, filename: "#{title.parameterize}.wav", content_type: "audio/wav")
  song.save!
  wav.close
  wav.unlink
  song
end

def rate_song(user, song, stars)
  Rating.find_or_create_by!(user: user, song: song) do |rating|
    rating.stars = stars
  end
end

users = {
  "demo-alice@true-shuffle.local" => { username: "alice", password: "password" },
  "demo-bob@true-shuffle.local" => { username: "bob", password: "password" },
  "demo-cara@true-shuffle.local" => { username: "cara", password: "password" }
}

alice = find_or_create_user("demo-alice@true-shuffle.local", "alice", "password")
bob = find_or_create_user("demo-bob@true-shuffle.local", "bob", "password")
cara = find_or_create_user("demo-cara@true-shuffle.local", "cara", "password")

song_a1 = find_or_create_song(alice, "Ocean Static")
song_a2 = find_or_create_song(alice, "Midnight Drift")
song_b1 = find_or_create_song(bob, "Skyline Echo")
song_c1 = find_or_create_song(cara, "Golden Hour")

rate_song(bob, song_a1, 4)
rate_song(cara, song_a2, 5)
rate_song(alice, song_b1, 3)

puts "Seeded demo users, songs, and ratings."
