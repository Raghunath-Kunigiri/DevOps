#!/bin/bash

# ==============================================================================
# An Interactive Script to Learn 105 Linux Commands
# ==============================================================================
# This script is designed to be a safe, educational tool. It creates a
# temporary "playground" directory to demonstrate commands without affecting
# your system files.
#
# How to run:
# 1. Save this file as learn_commands.sh
# 2. Make it executable: chmod +x learn_commands.sh
# 3. Run it: ./learn_commands.sh
# ==============================================================================

# --- Helper function to print headers and pause ---
function run_command() {
    local cmd_num=$1
    local cmd_name=$2
    local cmd_desc=$3
    local cmd_to_run=$4
    local is_safe=${5:-true}

    echo "----------------------------------------------------------------------"
    echo "Command #$cmd_num: $cmd_name"
    echo "----------------------------------------------------------------------"
    echo "Description: $cmd_desc"
    echo
    echo "Command to be executed: "
    echo "  \$ $cmd_to_run"
    echo

    if [ "$is_safe" = true ]; then
        # Execute the command
        eval "$cmd_to_run"
    else
        echo "NOTE: This command is potentially dangerous or requires special permissions."
        echo "It will NOT be executed automatically. You can run it manually if you wish."
    fi

    echo
    read -p "Press [Enter] to continue to the next command..."
    clear
}

# --- Setup a safe playground ---
clear
echo "Welcome to the Interactive Linux Command Learning Script!"
echo
echo "This script will walk you through 105 common Linux commands."
echo "First, we will create a safe 'playground' directory in your home folder."
echo "All file and directory operations will happen inside this playground."
echo

PLAYGROUND_DIR=~/linux_command_playground
read -p "Press [Enter] to create the playground at $PLAYGROUND_DIR..."

# Create the playground and some dummy content
mkdir -p "$PLAYGROUND_DIR/sub_dir"
touch "$PLAYGROUND_DIR/file1.txt"
touch "$PLAYGROUND_DIR/file2.log"
echo "Hello World" > "$PLAYGROUND_DIR/hello.txt"
echo -e "apple\nbanana\napple\ncherry\nbanana" > "$PLAYGROUND_DIR/fruits.txt"
echo -e "line one\nline two\nline three" > "$PLAYGROUND_DIR/file_A.txt"
echo -e "line one\nline ZZZ\nline three" > "$PLAYGROUND_DIR/file_B.txt"

# A simple C program for demonstration
cat << 'EOF' > "$PLAYGROUND_DIR/hello.c"
#include <stdio.h>
int main() {
   printf("Hello from C!\n");
   return 0;
}
EOF

# A simple Makefile
cat << 'EOF' > "$PLAYGROUND_DIR/Makefile"
hello: hello.c
	gcc -o hello hello.c
clean:
	rm -f hello
EOF

# A simple script for the 'source' command
cat << 'EOF' > "$PLAYGROUND_DIR/my_vars.sh"
#!/bin/bash
MY_VARIABLE="This variable was set by sourcing a file."
EOF


cd "$PLAYGROUND_DIR"

# Let's begin!
clear

# --- Basic Commands ---
run_command 1 "pwd" "Print the current working directory." "pwd"
run_command 2 "ls" "List files and directories. '-l' gives a long format." "ls -l"
run_command 3 "cd" "Change directory. We will change into 'sub_dir'." "cd sub_dir && pwd"
run_command 3 "cd" "Now let's go back to the parent directory." "cd .. && pwd"
run_command 4 "touch" "Create a new empty file named 'empty_file.txt'." "touch empty_file.txt && ls"
run_command 5 "mkdir" "Create a new directory named 'another_dir'." "mkdir another_dir && ls"
run_command 6 "rm" "Remove a file. We will remove 'empty_file.txt'." "rm empty_file.txt && ls"
run_command 7 "rmdir" "Remove an EMPTY directory. We will remove 'another_dir'." "rmdir another_dir && ls"
run_command 8 "cp" "Copy a file. We will copy 'hello.txt' to 'hello_copy.txt'." "cp hello.txt hello_copy.txt && ls"
run_command 9 "mv" "Move or rename a file. We will rename 'hello_copy.txt' to 'greeting.txt'." "mv hello_copy.txt greeting.txt && ls"
run_command 10 "cat" "Display the content of a file. We will display 'hello.txt'." "cat hello.txt"
run_command 11 "echo" "Display a line of text. The '>' symbol redirects the output to a file." "echo 'A new line of text' > new_file.txt && cat new_file.txt"
run_command 12 "clear" "Clear the terminal screen. This command will run after you press Enter." "sleep 0" && clear

# --- Intermediate Commands ---
run_command 13 "chmod" "Change file permissions. '+x' makes a file executable." "touch script.sh && chmod +x script.sh && ls -l script.sh"
run_command 14 "chown" "Change file ownership. This may fail if you are not the root user." "touch owner_test.txt && chown \$(whoami) owner_test.txt && ls -l owner_test.txt" false
run_command 15 "find" "Search for files. We will find all files ending in '.txt'." "find . -name '*.txt'"
run_command 16 "grep" "Search for text within a file. We will find lines with 'Hello' in 'hello.txt'." "grep 'Hello' hello.txt"
run_command 17 "wc" "Count lines, words, and characters in a file." "wc hello.txt"
run_command 18 "head" "Display the first few lines of a file. We will show the first 2 lines of 'fruits.txt'." "head -n 2 fruits.txt"
run_command 19 "tail" "Display the last few lines of a file. We will show the last 2 lines of 'fruits.txt'." "tail -n 2 fruits.txt"
run_command 20 "sort" "Sort the contents of a file." "echo 'Original fruits.txt:' && cat fruits.txt && echo -e '\nSorted fruits.txt:' && sort fruits.txt"
run_command 21 "uniq" "Remove DUPLICATE ADJACENT lines. Best used with 'sort'." "echo 'Sorted with duplicates:' && sort fruits.txt && echo -e '\nSorted and unique:' && sort fruits.txt | uniq"
run_command 22 "diff" "Compare two files and show the differences." "diff file_A.txt file_B.txt"
run_command 23 "tar" "Archive files. '-cvf' creates a new archive file." "tar -cvf archive.tar file1.txt file2.log && ls"
run_command 24 "zip/unzip" "Compress and extract ZIP files. (Requires zip/unzip to be installed)." "zip archive.zip hello.txt && ls" true
run_command 24 "zip/unzip" "Now let's unzip the archive." "unzip -l archive.zip" true
run_command 25 "df" "Display disk space usage for filesystems." "df -h"
run_command 26 "du" "Display directory size. We will check the size of our playground." "du -sh ."
run_command 27 "top" "Monitor system processes in real-time. We will run it for one iteration." "top -b -n 1 | head -n 15"
run_command 28 "ps" "Display your active processes." "ps u"
run_command 29 "kill" "Terminate a process. We will start a background 'sleep' process and then kill it." "echo 'Starting a background sleep process...' && sleep 300 & jobs && echo 'Killing the process...' && kill %1 && echo 'Process killed.' && jobs"
run_command 30 "ping" "Check network connectivity to a host. We will ping google.com 3 times." "ping -c 3 google.com"
run_command 31 "wget" "Download files from the internet. (Requires wget to be installed)." "wget -O google_index.html http://www.google.com && ls" false
run_command 32 "curl" "Transfer data. We will fetch the headers from google.com." "curl -I http://www.google.com"
run_command 33 "scp" "Securely copy files between systems. This requires a remote host." "echo 'Example: scp file.txt user@remotehost:/remote/dir'" false
run_command 34 "rsync" "Synchronize files and directories. This requires a remote host." "echo 'Example: rsync -avz local/dir/ user@remotehost:/remote/dir'" false

# --- Advanced Commands ---
run_command 35 "awk" "Text processing. We will print the first column of 'fruits.txt'." "awk '{print \$1}' fruits.txt"
run_command 36 "sed" "Stream editor. We will replace 'World' with 'Linux' in 'hello.txt'." "sed 's/World/Linux/' hello.txt"
run_command 37 "cut" "Remove sections from lines. We will cut the first 5 characters." "cut -c 1-5 hello.txt"
run_command 38 "tr" "Translate or delete characters. We will change lowercase 'l' to uppercase 'L'." "cat hello.txt | tr 'l' 'L'"
run_command 39 "xargs" "Build and execute commands from standard input." "echo 'file1.txt hello.txt' | xargs ls -l"
run_command 40 "ln" "Create links. We will create a symbolic link to 'hello.txt'." "ln -s hello.txt hello_link && ls -l"
run_command 41 "df -h" "(Duplicate) Display disk usage in human-readable format." "df -h"
run_command 42 "free" "Display memory usage." "free -h"
run_command 43 "iostat" "Display CPU and I/O statistics. (May need to be installed)." "iostat" false
run_command 44 "netstat" "Display network statistics. 'ss' is the modern replacement." "ss -tuna"
run_command 45 "ifconfig/ip" "Configure network interfaces. 'ip' is the modern command." "ip addr"
run_command 46 "iptables" "Configure firewall rules. We will list current rules (requires sudo)." "sudo iptables -L -n" false
run_command 47 "systemctl" "Control the systemd system and service manager. We will check the status of sshd." "systemctl status sshd" false
run_command 48 "journalctl" "View system logs. We will view the last 5 kernel messages." "journalctl --no-pager -k -n 5"
run_command 49 "crontab" "Schedule recurring tasks. We will list the current user's cron jobs." "crontab -l" false
run_command 50 "at" "Schedule tasks for a specific time. This command is interactive." "echo 'Example: at now + 1 minute (then type commands)'" false
run_command 51 "uptime" "(Duplicate) Display system uptime." "uptime"
run_command 52 "whoami" "(Duplicate) Display the current user." "whoami"
run_command 53 "users" "List all users currently logged in." "users"
run_command 54 "hostname" "Display or set the system hostname." "hostname"
run_command 55 "env" "Display environment variables." "env | head -n 10"
run_command 56 "export" "Set environment variables for the current shell." "export MY_TEMP_VAR='Hello from export' && echo \$MY_TEMP_VAR"

# --- Networking Commands ---
run_command 57 "ip addr" "(Duplicate) Display or configure IP addresses." "ip addr"
run_command 58 "ip route" "Show or manipulate routing tables." "ip route"
run_command 59 "traceroute" "Trace the route packets take to a host. (May need to be installed)." "traceroute google.com" false
run_command 60 "nslookup" "Query DNS records." "nslookup google.com"
run_command 61 "dig" "Query DNS servers. (More detailed than nslookup)." "dig google.com"
run_command 62 "ssh" "Connect to a remote server. This command is interactive." "echo 'Example: ssh user@remotehost'" false
run_command 63 "ftp" "Transfer files using FTP. This command is interactive." "echo 'Example: ftp ftp.example.com'" false
run_command 64 "nmap" "Network scanning. We will scan localhost. (May need to be installed)." "nmap localhost" false
run_command 65 "telnet" "Communicate with remote hosts. This command is interactive." "echo 'Example: telnet google.com 80'" false
run_command 66 "netcat (nc)" "Read/write data over networks. We will test a port on localhost." "nc -zv localhost 22"

# --- File Management and Search ---
run_command 67 "locate" "Find files quickly using a database. (May need to run 'sudo updatedb' first)." "locate hello.txt" false
run_command 68 "stat" "Display detailed information about a file." "stat hello.txt"
run_command 69 "tree" "Display directories as a tree. (May need to be installed)." "tree ." false
run_command 70 "file" "Determine a file’s type." "file hello.txt"
run_command 71 "basename" "Extract the filename from a path." "basename /etc/hosts"
run_command 72 "dirname" "Extract the directory part of a path." "dirname /etc/hosts"

# --- System Monitoring ---
run_command 73 "vmstat" "Display virtual memory statistics." "vmstat 1 3"
run_command 74 "htop" "Interactive process viewer. This command is interactive." "echo 'htop is an improved version of top. Run it manually.'" false
run_command 75 "lsof" "List open files. (May require sudo)." "lsof -i :22" false
run_command 76 "dmesg" "Print kernel ring buffer messages. (May require sudo)." "dmesg | tail -n 10" false
run_command 77 "uptime" "(Duplicate) Show how long the system has been running." "uptime"
run_command 78 "iotop" "Display real-time disk I/O. This command is interactive and requires sudo." "echo 'iotop shows disk I/O per process. Run with sudo.'" false

# --- Package Management ---
run_command 79 "apt" "Package manager for Debian-based distros. We will search for 'htop'." "apt search htop" false
run_command 80 "yum/dnf" "Package manager for RHEL-based distros. We will search for 'htop'." "dnf search htop" false
run_command 81 "snap" "Manage snap packages. We will list installed snaps." "snap list" false
run_command 82 "rpm" "Manage RPM packages. We will query for the 'bash' package." "rpm -q bash" false

# --- Disk and Filesystem ---
run_command 83 "mount/umount" "Mount or unmount filesystems. DANGEROUS to execute randomly." "mount | head -n 5"
run_command 84 "fsck" "Check and repair filesystems. EXTREMELY DANGEROUS to execute randomly." "echo 'WARNING: fsck should only be run on unmounted filesystems by experts.'" false
run_command 85 "mkfs" "Create a new filesystem. EXTREMELY DANGEROUS to execute randomly." "echo 'WARNING: mkfs will WIPE a partition. Never run this without expert knowledge.'" false
run_command 86 "blkid" "Display information about block devices. (Requires sudo)." "sudo blkid" false
run_command 87 "lsblk" "List information about block devices. (Safer)." "lsblk"

# --- Scripting and Automation ---
run_command 89 "bash" "This entire script is running in bash!" "echo \"Current shell: \$SHELL\""
run_command 90 "sh" "A legacy shell. Often a symlink to bash or dash." "sh --version" false
run_command 91 "cron" "(Duplicate) Automate tasks. See crontab." "echo 'See command #49: crontab'"
run_command 92 "alias" "Create shortcuts for commands." "alias myls='ls -la' && echo \"Alias 'myls' created for this session.\""
run_command 93 "source" "Execute commands from a file in the current shell." "source my_vars.sh && echo \$MY_VARIABLE"

# --- Development and Debugging ---
run_command 94 "gcc" "Compile C programs. We will compile hello.c." "gcc -o hello hello.c && ls"
run_command 94 "gcc" "Now let's run the compiled program." "./hello"
run_command 95 "make" "Build and manage projects using a Makefile." "make"
run_command 95 "make" "Now let's run the program built with make." "./hello"
run_command 96 "strace" "Trace system calls and signals. We will trace the 'ls' command." "strace ls" false
run_command 97 "gdb" "The GNU Debugger. This is an interactive tool." "echo 'Example: gdb ./hello'" false
run_command 98 "git" "Version control system." "git --version"
run_command 99 "vim/nano" "Text editors. These are interactive." "echo 'Nano and Vim are powerful terminal-based text editors.'" false

# --- Other Useful Commands ---
run_command 100 "uptime" "(Duplicate) Display system uptime." "uptime"
run_command 101 "date" "Display or set the system date and time." "date"
run_command 102 "cal" "Display a calendar." "cal"
run_command 103 "man" "Display the manual for a command." "echo 'Example: man ls'" false
run_command 104 "history" "Show previously executed commands." "history | tail -n 10"
run_command 105 "alias" "(Duplicate) Create custom shortcuts for commands." "alias"

# --- Cleanup ---
cd ~
echo "----------------------------------------------------------------------"
echo "Congratulations! You have completed the tour of 105 Linux commands."
echo
read -p "Do you want to remove the playground directory? ($PLAYGROUND_DIR) [y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    rm -rf "$PLAYGROUND_DIR"
    echo "Playground directory removed."
else
    echo "Playground directory was not removed."
fi

echo "Happy learning!"

