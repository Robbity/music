# Shuffle

Shuffle is a music listening app focused on giving small artists real feedback without promotion fees or algorithmic feeds. Users get a daily track, rate it once, and can choose to save it to their library. Guests see the top-rated track of the day, while signed-in users receive a consistent daily pick.

## Tech stack

- Ruby on Rails 8.1
- Hotwire (Turbo and Stimulus) with importmap for frontend behavior
- PostgreSQL for data
- Active Storage with S3 for audio and artwork
- Minitest with SimpleCov for testing
- Docker and Kamal for deployment

## Development

Run the app:

```sh
bin/rails server
```

Run tests:

```sh
bin/rails test
```
