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

        //// Fill visited cells for debugging
        //if (visited) {
        //    fill(200); // Light gray
        //    noStroke();
        //    rect(xPos, yPos, GRID_SIZE, GRID_SIZE);
        //}

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
    Cell[][] grid; // 2D grid of cells
    ArrayList<Cell> frontier = new ArrayList<Cell>(); // Frontier list for maze generation

    void generate() {
        println("Maze generation started...");
        frontier.clear(); // Clear the frontier

        // Determine grid dimensions
        int cols = width / GRID_SIZE;
        int rows = height / GRID_SIZE;

        // Initialize the grid
        grid = new Cell[cols][rows];
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                grid[i][j] = new Cell(i, j); // Create all cells with walls
            }
        }

        println("Grid initialized with " + cols + " columns and " + rows + " rows.");

        // Start maze generation at a random cell
        Cell start = grid[(int) random(cols)][(int) random(rows)];
        start.visited = true;
        addNeighborsToFrontier(start);

        // Process all cells in the frontier
        while (!frontier.isEmpty()) {
            Cell current = frontier.remove((int) random(frontier.size())); // Randomly pick a frontier cell
            Cell neighbor = getUnvisitedNeighbor(current);

            if (neighbor != null) {
                // Remove walls between current and neighbor
                removeWall(current, neighbor);

                // Mark the neighbor as visited and add its neighbors
                neighbor.visited = true;
                addNeighborsToFrontier(neighbor);
            }
        }

        println("Maze generation completed.");
    }

    void draw() {
        if (grid != null) {
            for (int i = 0; i < grid.length; i++) {
                for (int j = 0; j < grid[i].length; j++) {
                    grid[i][j].draw(); // Render each cell
                }
            }
        }
    }

    void addNeighborsToFrontier(Cell cell) {
        for (Cell neighbor : getNeighbors(cell)) {
            if (!neighbor.visited && !frontier.contains(neighbor)) {
                frontier.add(neighbor);
                println("Added to frontier: " + neighbor.x + ", " + neighbor.y);
            }
        }
    }

    ArrayList<Cell> getNeighbors(Cell cell) {
        ArrayList<Cell> neighbors = new ArrayList<Cell>();
        int x = cell.x;
        int y = cell.y;

        // Add valid neighbors
        if (x > 0) neighbors.add(grid[x - 1][y]); // Left
        if (x < grid.length - 1) neighbors.add(grid[x + 1][y]); // Right
        if (y > 0) neighbors.add(grid[x][y - 1]); // Top
        if (y < grid[0].length - 1) neighbors.add(grid[x][y + 1]); // Bottom

        return neighbors;
    }

    Cell getUnvisitedNeighbor(Cell cell) {
        ArrayList<Cell> unvisited = new ArrayList<Cell>();

        // Collect unvisited neighbors
        for (Cell neighbor : getNeighbors(cell)) {
            if (!neighbor.visited) {
                unvisited.add(neighbor);
            }
        }

        // Return a random unvisited neighbor, if any
        if (!unvisited.isEmpty()) {
            return unvisited.get((int) random(unvisited.size()));
        }
        return null;
    }

    void removeWall(Cell current, Cell neighbor) {
        // Determine the relative position of the neighbor
        int xDiff = neighbor.x - current.x;
        int yDiff = neighbor.y - current.y;

        // Remove walls based on relative position
        if (xDiff == 1) { // Neighbor is to the right
            current.walls[1] = false; // Remove right wall of current
            neighbor.walls[3] = false; // Remove left wall of neighbor
        } else if (xDiff == -1) { // Neighbor is to the left
            current.walls[3] = false; // Remove left wall of current
            neighbor.walls[1] = false; // Remove right wall of neighbor
        } else if (yDiff == 1) { // Neighbor is below
            current.walls[2] = false; // Remove bottom wall of current
            neighbor.walls[0] = false; // Remove top wall of neighbor
        } else if (yDiff == -1) { // Neighbor is above
            current.walls[0] = false; // Remove top wall of current
            neighbor.walls[2] = false; // Remove bottom wall of neighbor
        }

        println("Removed wall between (" + current.x + ", " + current.y + ") and (" + neighbor.x + ", " + neighbor.y + ")");
    }
}
