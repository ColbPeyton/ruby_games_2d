require 'ruby2d'

set title:          'input'
set background:     'red'

curr_key = ''

x_movement = 180
y_movement = 180
x = 180
y = 180


update do
  case curr_key
  when 'd'
      x_movement += 1
  when 'a'
      x_movement -= 1
  when 'w'
      y_movement -= 1
  when 's'
      y_movement += 1
  end
  curr_key = ''
  if x  != x_movement or y != y_movement
      clear 
      Text.new(
          'player',
          x: x_movement, 
          y: y_movement,
          size: 20,
          color: 'white',
          z: 10
        )
      x = x_movement
      y = y_movement
  end
end

on :key do |event|
  curr_key = event.key.to_s
end
show