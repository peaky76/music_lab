require_relative('../db/sql_runner')
require_relative('./artist')

class Album

    attr_accessor :title, :genre, :artist_id
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @title = options['title']
        @genre = options['genre']
        @artist_id = options['artist_id'].to_i()
    end

    def save()
        sql = "INSERT INTO albums
        (title, genre, artist_id)
        VALUES ($1, $2, $3)
        RETURNING id"
        values = [@title, @genre, @artist_id]
        result = SqlRunner.run(sql, values)
        @id = result[0]['id'].to_i()
    end

    def update()
        sql = "UPDATE albums
        SET (title, genre) = ($1, $2)
        WHERE id = $3"
        values = [@title, @genre, @id]
        result = SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM albums"
        result = SqlRunner.run(sql)
        return result.map { |album| Album.new(album) }
    end

    def delete()
        sql = "DELETE FROM albums
        WHERE id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values)
    end

    def self.delete_all()
        sql = "DELETE FROM albums"
        result = SqlRunner.run(sql)
    end

    def artist()
        sql = "SELECT * FROM artists
        WHERE id = $1"
        values = [@artist_id]
        result = SqlRunner.run(sql, values)
        return result.map { |artist| Artist.new(artist)}
    end

    def self.find(id)
        sql = "SELECT * FROM albums
        WHERE id = $1"
        values = [id]
        result = SqlRunner.run(sql, values)[0]
        return Album.new(result)
    end

    def self.find_by_genre(genre)
        sql = "SELECT * FROM albums
        WHERE genre = $1"
        values = [genre]
        result = SqlRunner.run(sql, values)
        return result.map { |album| Album.new(album) }
    end

end
