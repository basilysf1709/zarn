# Zarn

## Documentation

### Phase #1:
<img width="687" alt="Screenshot 1446-02-21 at 4 26 37 PM" src="https://github.com/user-attachments/assets/cd9c96db-22a5-4c63-b210-f9599138bd68">

- Designed the diagram above
- Setting up build system
- Ran into issues with changing directories in the test system
- Connected commands.zig to cli.zig, which is then connected to cli_tests.zig for testing

### Phase #2:
<img width="665" alt="Screenshot 1446-02-21 at 4 27 15 PM" src="https://github.com/user-attachments/assets/9141de02-9d8c-4d68-a9df-79fe669f69cf">

- Trying to understand zig build
- Added a test to see if zarn.toml file with "init" command works properly

Zarn is a package manager written in Zig.

## Project Structure

The project is structured as follows:

- `src/`
  - `main.zig`: Entry point of the application
  - `package/`: Package-related functionality
  - `cli/`: Command-line interface implementation
  - `util/`: Utility functions
  - `resolver/`: Dependency resolution logic
- `build.zig`: Build configuration

## Building the Project

To build the project, you need to have Zig installed. Then run:

```
zig build
```

This will create an executable named `zarn` in the `zig-out/bin` directory.

## Running the Application

To run the application, use:

```
zig build run
```

Or, after building, you can directly run the executable:

```
./zig-out/bin/zarn
```

## Development

The main application logic is located in `src/main.zig`. Currently, it only prints "Hello, World!":

```zig:src/main.zig
startLine: 3
endLine: 5
```

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License
