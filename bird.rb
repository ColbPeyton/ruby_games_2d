require 'ruby2d'

set background: 'white'
set width: 1200
set height: 800

$total_obstacles = 3
$obstacles_on_screen = 1
$difficulty = 1
$total = 1
$total_score = 0
$game_over = false

class Bird
    def initialize
        @x = Window.width / 3
        @y = Window.height / 2
        @y_velocity = 5
        @jump_velocity = 10
        @color = Color.new('blue')
    end

    def draw
        @bird = Square.new(x: @x, y: @y, size: 15, color: @color)
    end

    def move
        @y = (@y + @y_velocity) % Window.height
    end

    def check_for_collision
        if @bird && collision_detected?
            $game_over = true
        end
    end

    def jump
        @y = (@y - @jump_velocity) % Window.height
    end

    def collision_detected?
        $obstacles.any? do |obstacle|
            if obstacle.score?(@bird)
                $total_score += 10
            end
            obstacle.include?(@bird)
        end
    end

end

class Obstacle
    def initialize
        @x_velocity = 5
        @color = Color.new('random')
        @height = rand(300..650)
        @width = 100
        @x = Window.width
        @y = render_y_position
    end

    def render_y_position 
        if rand(1..10) % 2 == 0
            pos = 0
        else
            pos = Window.height - @height
        end 
    end

    def draw
        @obstacle = Rectangle.new(x: @x, y: @y, width: @width, height: @height, color: @color, z: 10)
    end
    def draw_score_marker
        @score_marker = Rectangle.new(x: @x + @width / 2, y:0, width: 0, height: Window.height, color: 'red',z: 5)
    end

    def move
        @x = @x - @x_velocity
    end

    def delete_when_off_screen
        if @x <= 0 - @width
            $obstacles.shift
            $obstacles_on_screen -= 1
            if $obstacles_on_screen <= $total_obstacles
                $obstacles.push Obstacle.new
                $obstacles_on_screen += 1
                $total += 1
            end
            p $obstacles
        end
    end

    def add_to_screen
        if @x == Window.width / 2 && $obstacles_on_screen <= $total_obstacles && Window.frames % 60 == 0
            $obstacles.push Obstacle.new
            $obstacles_on_screen += 1
            $total += 1
        end
    end

    def increase_difficulty
        if $total == 5
            p 'increase'
            $difficulty += 5
            $total = 0
            @x_velocity += 5
            $total_obstacles += 1
        end
    end

    def include?(bird)
        @obstacle.contains?(bird.x1, bird.y1) ||
        @obstacle.contains?(bird.x2, bird.y2) ||
        @obstacle.contains?(bird.x3, bird.y3) ||
        @obstacle.contains?(bird.x4, bird.y4) 
    end
    def score?(bird)
        @score_marker.contains?(bird.x1, bird.y1)
    end
end



class Game
    def initalize(bird, obstacles)
        @bird = bird
        @obstacles = obstacles
        @total_obstacles = 3
        @obstacles_on_screen = 1
        @difficulty = 1
        @total = 1
        @total_score = 0
        @game_over = false
        @paused = false
    end

    def draw
        unless game_over?

        end
        on_screen_text
    end

    def add_to_score(obstacle)
        if obstacle.score?
            @score += 10
        end

    end

    def game_over
        @game_over = true
    end

    def game_over?
        @game_over
    end

    def pause
        @paused = true
    end

    def unpause
        @paused = false
    end

    def paused?
        @paused
    end

    private
    
    def on_screen_text
        if game_over?
            Text.new(
                "Game over, score: #{@score}. Press 'R' to restart, 'Q' to quit.",
                x: Window.width / 2 - 150, y: Window.height / 4,
                style: 'bold',
                size: 50,
                color: 'red',
                z: 35
              )    
        elsif paused?
            Text.new(
                "Game paused, score: #{@score}. Press 'P' to resume.",
                x: Window.width / 2 - 150, y: Window.height / 4,
                style: 'bold',
                size: 50,
                color: 'red',
                z: 35
              )    
        else 
            Text.new(
                "Score: #{@score}",
                x: 0, y: 0,
                size: 35,
                color: 'black',
                z: 25
              )
        end
    end
end

bird = Bird.new
obstacles = Array.new(1) { Obstacle.new }
game = Game.new(bird, obstacles)

update do
    clear
    unless game.game_over? or game.paused?
        bird.check_for_collision
        bird.move
        obstacles.each do |obstacle|
            obstacle.move
        end
    end
    bird.draw
    obstacles.each do |obstacle|
        obstacle.draw
        obstacle.draw_score_marker
        obstacle.delete_when_off_screen
        obstacle.add_to_screen
        obstacle.increase_difficulty
    end
    
end

on :key_held do |event|
    if event.key == 'space' && $game_over == false
        $bird.jump
    end
end

on :key do |event|
    if event.key == 'space' && $game_over
        reset_game
    end
end

show