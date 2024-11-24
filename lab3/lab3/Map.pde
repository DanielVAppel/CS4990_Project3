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

        stroke(0);
        if (walls[0]) line(xPos, yPos, xPos + GRID_SIZE, yPos); // Top wall
        if (walls[1]) line(xPos + GRID_SIZE, yPos, xPos + GRID_SIZE, yPos + GRID_SIZE); // Right wall
        if (walls[2]) line(xPos, yPos + GRID_SIZE, xPos + GRID_SIZE, yPos + GRID_SIZE); // Bottom wall
        if (walls[3]) line(xPos, yPos, xPos, yPos + GRID_SIZE); // Left wall
    }
}

class Map {
    Cell[][] grid;
    ArrayList<Cell> frontier = new ArrayList<Cell>();

    void generate() {
        int cols = width / GRID_SIZE;
        int rows = height / GRID_SIZE;

        // Initialize grid
        grid = new Cell[cols][rows];
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                grid[i][j] = new Cell(i, j);
            }
        }

        // Start with a random cell
        Cell start = grid[int(random(cols))][int(random(rows))];
        start.visited = true;
        addNeighborsToFrontier(start);

        // Maze generation using Prim's algorithm
        while (!frontier.isEmpty()) {
            Cell current = frontier.remove(int(random(frontier.size())));
            Cell neighbor = getUnvisitedNeighbor(current);

            if (neighbor != null) {
                removeWall(current, neighbor);
                neighbor.visited = true;
                addNeighborsToFrontier(neighbor);
            }
        }
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

    void addNeighborsToFrontier(Cell cell) {
        for (Cell neighbor : getNeighbors(cell)) {
            if (neighbor != null && !neighbor.visited && !frontier.contains(neighbor)) {
                frontier.add(neighbor);
            }
        }
    }

    ArrayList<Cell> getNeighbors(Cell cell) {
        ArrayList<Cell> neighbors = new ArrayList<Cell>();
        int x = cell.x;
        int y = cell.y;

        if (x > 0) neighbors.add(grid[x - 1][y]); // Left
        if (x < grid.length - 1) neighbors.add(grid[x + 1][y]); // Right
        if (y > 0) neighbors.add(grid[x][y - 1]); // Top
        if (y < grid[0].length - 1) neighbors.add(grid[x][y + 1]); // Bottom

        return neighbors;
    }

    Cell getUnvisitedNeighbor(Cell cell) {
        ArrayList<Cell> neighbors = new ArrayList<Cell>();
        for (Cell neighbor : getNeighbors(cell)) {
            if (neighbor != null && !neighbor.visited) neighbors.add(neighbor);
        }
        return neighbors.isEmpty() ? null : neighbors.get(int(random(neighbors.size())));
    }

    void removeWall(Cell current, Cell neighbor) {
        int xDiff = neighbor.x - current.x;
        int yDiff = neighbor.y - current.y;

        if (xDiff == 1) { // Neighbor is to the right
            current.walls[1] = false;
            neighbor.walls[3] = false;
        } else if (xDiff == -1) { // Neighbor is to the left
            current.walls[3] = false;
            neighbor.walls[1] = false;
        } else if (yDiff == 1) { // Neighbor is below
            current.walls[2] = false;
            neighbor.walls[0] = false;
        } else if (yDiff == -1) { // Neighbor is above
            current.walls[0] = false;
            neighbor.walls[2] = false;
        }
    }
}
