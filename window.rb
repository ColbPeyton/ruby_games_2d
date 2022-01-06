require 'ruby2d'

set title:          'Hello World'
set background:     'blue'
set width:          800
set height:         600
tick = 0

update do
    if tick % 60 == 0    
        p "x: #{get :mouse_x}"
        p "y: #{get :mouse_y}"
    end
    tick += 1
end
show