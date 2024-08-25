# Zarn

## Documentation

### Phase #1:
<img width="1006" alt="Screenshot 1446-02-21 at 1 49 26 AM" src="https://github.com/user-attachments/assets/31cd4160-5606-4e0c-b70e-920413fb6caa">

- Designed the diagram above
- Setting up build system
- Ran into issues with changing directories in the test system
- Connected commands.zig to cli.zig, which is then connected to cli_tests.zig for testing


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
