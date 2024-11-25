class Cell {
    int x, y; // Position in the grid
    boolean[] walls = {true, true, true, true}; // {top, right, bottom, left}
    boolean visited = false;

    Cell(int x, int y) {
        this.x = x;
        this.y = y;
    }

    void draw() {
        int xPos = x * GRID_SIZE;
        int yPos = y * GRID_SIZE;

        // Fill visited cells for debugging
        if (visited) {
            fill(200); // Light gray
            noStroke();
            rect(xPos, yPos, GRID_SIZE, GRID_SIZE);
        }

        // Draw walls
        stroke(0); // Black for walls
        noFill();
        if (walls[0]) line(xPos, yPos, xPos + GRID_SIZE, yPos); // Top wall
        if (walls[1]) line(xPos + GRID_SIZE, yPos, xPos + GRID_SIZE, yPos + GRID_SIZE); // Right wall
        if (walls[2]) line(xPos, yPos + GRID_SIZE, xPos + GRID_SIZE, yPos + GRID_SIZE); // Bottom wall
        if (walls[3]) line(xPos, yPos, xPos, yPos + GRID_SIZE); // Left wall
    }
}

class Map {
    Cell[][] grid;
    Stack<Cell> stack = new Stack<Cell>();

    void generate() {
        println("Maze generation started...");
        stack.clear();

        int cols = width / GRID_SIZE;
        int rows = height / GRID_SIZE;

        // Initialize grid
        grid = new Cell[cols][rows];
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                grid[i][j] = new Cell(i, j);
            }
        }

        // Start maze generation at a random cell
        Cell start = grid[(int) random(cols)][(int) random(rows)];
        start.visited = true;
        stack.push(start);

        while (!stack.isEmpty()) {
            Cell current = stack.peek();
            Cell neighbor = getUnvisitedNeighbor(current);

            if (neighbor != null) {
                // Remove wall between current cell and neighbor
                removeWall(current, neighbor);
                neighbor.visited = true;

                // Push neighbor to stack to continue the path
                stack.push(neighbor);
            } else {
                // Backtrack when no unvisited neighbors are left
                stack.pop();
            }
        }

        println("Maze generation completed.");
    }

    void draw() {
        if (grid != null) {
            for (int i = 0; i < grid.length; i++) {
                for (int j = 0; j < grid[i].length; j++) {
                    grid[i][j].draw();
                }
            }
        }
    }

    ArrayList<Cell> getNeighbors(Cell cell) {
        ArrayList<Cell> neighbors = new ArrayList<Cell>();
        int x = cell.x;
        int y = cell.y;

        if (x > 0) neighbors.add(grid[x - 1][y]);
        if (x < grid.length - 1) neighbors.add(grid[x + 1][y]);
        if (y > 0) neighbors.add(grid[x][y - 1]);
        if (y < grid[0].length - 1) neighbors.add(grid[x][y + 1]);

        return neighbors;
    }

    Cell getUnvisitedNeighbor(Cell cell) {
        ArrayList<Cell> unvisited = new ArrayList<Cell>();

        for (Cell neighbor : getNeighbors(cell)) {
            if (!neighbor.visited) {
                unvisited.add(neighbor);
            }
        }

        if (!unvisited.isEmpty()) {
            return unvisited.get((int) random(unvisited.size()));
        }
        return null;
    }

    void removeWall(Cell current, Cell neighbor) {
        int xDiff = neighbor.x - current.x;
        int yDiff = neighbor.y - current.y;

        if (xDiff == 1) {
            current.walls[1] = false;
            neighbor.walls[3] = false;
        } else if (xDiff == -1) {
            current.walls[3] = false;
            neighbor.walls[1] = false;
        } else if (yDiff == 1) {
            current.walls[2] = false;
            neighbor.walls[0] = false;
        } else if (yDiff == -1) {
            current.walls[0] = false;
            neighbor.walls[2] = false;
        }

    }
}
