import argparse
import subprocess
import sys

def execute_cli_command(command_args):
    """
    Executes a command-line operation with the given arguments.

    Args:
        command_args: A list of strings representing the command and its arguments.

    Returns:
        A tuple containing the return code, stdout, and stderr of the executed command.
    """
    try:
        # Execute the command
        result = subprocess.run(
            command_args,
            capture_output=True,
            text=True,
            check=False  # Do not raise an exception for non-zero exit codes
        )
        return result.returncode, result.stdout, result.stderr
    except FileNotFoundError:
        return 1, "", f"Error: Command '{command_args[0]}' not found."
    except Exception as e:
        return 1, "", f"An unexpected error occurred: {e}"

def main():
    """
    Parses command-line arguments and executes the specified command.
    """
    parser = argparse.ArgumentParser(
        description="Execute command-line operations with arguments."
    )
    # Use nargs='+' to capture all subsequent arguments as part of the command
    parser.add_argument(
        "command",
        nargs='+',
        help="The command and its arguments to execute (e.g., 'ls -l /home/user')"
    )

    # Parse the arguments
    args = parser.parse_args()

    # Execute the command
    return_code, stdout, stderr = execute_cli_command(args.command)

    # Print the output
    if stdout:
        print("--- STDOUT ---")
        print(stdout)
    if stderr:
        print("--- STDERR ---")
        print(stderr)

    # Exit with the command's return code
    sys.exit(return_code)

if __name__ == "__main__":
    main()