f = open('maze_5bit.txt', 'w')
with open('maze_original.txt') as maze:
    maze = [line.split() for line in maze]
    for y in range(len(maze)):
        for x in range(len(maze[y])):
            maze[y][x] = int(maze[y][x])
            if(maze[y][x]):
                print(maze[y][x], end=' ')
            else:
                print('  ', end='')
        print()

    for y in range(len(maze)):
        for x in range(len(maze[y])):
            out = maze[y][x]
            if y > 0 and maze[y-1][x]:
                out |= 0b00010  # up
            if x < len(maze[y])-1 and maze[y][x+1]:
                out |= 0b00100  # right
            if y < len(maze)-1 and maze[y+1][x]:
                out |= 0b01000  # down
            if x > 0 and maze[y][x-1]:
                out |= 0b10000  # left

            print(bin(out)[2:].zfill(5), end=' ')
            f.write(bin(out)[2:].zfill(5) + '\n')
        print()
