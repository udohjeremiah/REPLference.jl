@doc raw"""
# FILES
In programming, a file is simply a container used for storing data (such as documents,
pictures, audio, etc.) in digital format. They can be stored on hard drives, optical drives,
flash drives, or other types of storage devices and can be shared and transferred between
computers through removable media, networks, or the internet.

### File Names
In computers, files are identified by a filename. A filename is a unique name used to
identify a file in a directory structure. Different file systems have different restrictions
on filename length and the characters that can be used. For example, some operating systems
do not allow spaces in filenames, so it's suggested to use an underscore instead.

### File Formats
A file format is a standard way of encoding information for storage in a computer file. It
specifies how bits are used to encode information in a digital storage medium. File formats
can be either proprietary or free.

One common method used by many operating systems to determine a file's format is to examine
the end of its name, specifically the letters following the final period. This part of the
filename is referred to as the "filename extension." For instance, HTML documents are
identified by names ending with .html or .htm, and GIF images by .gif.

### File Extensions
A filename extension, also known as a file extension, is a suffix added to the name of a
file (e.g. .txt, .docx, .md). The extension indicates the characteristics of the file's
contents and its intended use. The extension is typically separated from the rest of the
filename by a period, but in some systems, it may be separated by spaces.

Some file systems consider filename extensions as a feature of the file system and impose
restrictions on the length and format of the extension. Others treat the filename extension
as just a part of the filename without any special distinction.

### File Directory
While "files" are used to store digital data, "directories" are used to organize "files". In
computing, a directory is a location for storing files on your computer in a structured way.
It's a file system for cataloging and contains references to other files and possibly other
directories. A directory contained within another directory is called a "subdirectory". On
many computers, directories are referred to as folders, similar to a traditional office
filing cabinet.

### File Pathname
A "pathname" is a unique label for the location of a file within a directory in an operating
system. They are useful for locating individual files within directories, particularly in
source code and command-line operations. A pathname is a combination of slash (`/`) and
alphanumeric characters representing the names of directories, e.g.,
`/directory1/directory2/directory3/file`. Pathnames can be either *absolute* or
*relative*.

An absolute pathname represents the complete name of a directory or file, starting from the
root (`/`) directory. Since it starts from the root directory, absolute pathnames always
begin with a slash (`/`).

A relative pathname, on the other hand, describes the location of a file relative to the
current working directory. Since it starts from the current directory, it can traverse its
parent or subdirectories, and files, relative pathnames do not begin with a slash (`/`).

For example, if we have a directory named `Documents`, with a subdirectory named `Sales`,
and a file under that subdirectory named `file1.txt`, to access `file1.txt`, we can either:

- specify the absolute pathname from the `/` (root) directory: `/Documents/Sales/file1.txt`.
- specify the relative pathname (if we're currently in the `/Documents/Sales/ directory`):
  `file1.txt`.

In pathnames, dots can represent the parent or current working directories. A dot (`.`)
refers to the current working directory, and double dots (`..`) refer to the parent
directory of the current working directory. For example, if we're in the `/Documents/Sales`
directory, we can specify the pathname of `file1.txt` as `./file1.txt`, and the dot would be
interpreted as `/Documents/Sales`. However, if we specify the pathname as `../file1.txt`,
the dot would be interpreted as `/Documents`, which would result in an error if
`/Documents/file1.txt` does not exist.

File pathnames allow us to have multiple files with the same name as long as they are in
different directories. For example, `/Documents/Sales/file1.txt` and
`Documents/Orders/file1.txt` both refer to different files with the name `file1.txt`.

### File System
A file system (often abbreviated to fs) is the structure and set of logical rules used by an
operating system to organize and manage data in a computer. It controls how data is stored
and retrieved on a computer.

Without a file system, data stored on a medium would be a single, undifferentiated mass with
no way to identify or locate specific pieces of data. By breaking the data into smaller
pieces and assigning each a unique name, it becomes easier to isolate and access the data.

### File Manager
A file manager is a computer program that helps a user manage all the files and folders on
their computer. It provides the user interface for creating, opening (such as viewing,
playing, editing, or printing), renaming, copying, moving, deleting, and searching for
files, as well as modifying file attributes, properties, and permissions. Folders and files
can be displayed in a hierarchical tree based on their directory structure. Most modern
operating systems have their built-in file managers, such as "My Computer" in Windows and
"Finder" in macOS. However, there are also many third-party file managers available.

# Types Of Files
In computing, files recognized by an operating system can generally be categorized into
three basic types: regular, directory, and special files.

### Regular Files
Regular files are the most common type used directly by a human user, such as text files,
image files, binary files, executable files, and shared libraries. When creating a new file
on a computer, it is typically a regular file.

Regular files can be divided into two categories: application files and data files.

- Application or program files, also known as executable files (runnable programs), convert
  commands or data from other files into binary form so that the processor can interpret and
  execute them. Examples include programming compilers, text editors, music and video
  players, etc.

- Data files store information to be used by application files, including input and output
  data. Unlike application files, data files don't perform operations on the computer, but
  rather contain information to be acted upon by the application files. They are usually
  divided into two types: text files and binary files.
  - Text files, also known as ASCII files, contain human-readable characters and store
    information in ASCII format. They can be edited using a text editor and examples
    include text documents and source codes.
  - Binary files contain information in the same format as it is held in memory, as binary
    digits of 0s and 1s. Examples include graphic files, audio files, and video files.

### Directory Files
As mentioned earlier, "directories" are used to organize "files"; however, they are
themselves also considered "files". To differentiate a "directory" from a "file", we use the
term "directory file". A directory file contains a list of the files in that directory.

### Special Files
A special file, also known as a device file, is used with device drivers to expose the
device as a file in the file system. For example, special files transfer data from CD-ROMs
to computers. The three basic types of special files are FIFO (first-in, first-out), also
called pipes, block, and character.

Although they may appear and act like regular files, there is an important difference
between the two. A regular file is a logical grouping of data recorded on disk, while a
special file corresponds to a device entity. Special files have unique names that
distinguish them from other files, and these names cannot be used for any other file types.

# Input/Output
Computer programs often need to communicate with the outside world. A typical scenario is
the keyboard, an input device, communicating with a monitor, an output device, through
typing letters on the keyboard and display on the monitor. This communication, however, is
not limited to the keyboard and monitor; computer programs can also communicate through
stored data, such as files. All communication between input and output devices is done
through a *stream*.

A stream is a sequence of flowing data that acts as the communication channel between a data
source, such as the outside world, and a computer program. It is the medium through which
data travels in succession. There are two basic types of data streaming in a computer: input
streams and output streams.

Input streams are used to read input from an input source, which can be anything that can
contain data. Examples of input sources are keyboards, files, and internet resources.

Output streams are used to write data to an output source, which can be anything that can
receive and potentially process data, such as a monitor or printer. Examples of output
streams are strings, memory, images, and audio.

# File Handling
The entire process of working with files in computer programs is known as file handling
(or file I/O). File handling, in any computer language, simply means working with files. It
offers a convenient abstraction for programmers to use, as it allows them to focus on
writing their applications and not the low-level system calls needed to access these files
on the computer hard disk.

The most basic operations that programs can perform when working with files, collectively,
are called file handling operations. These operations are: creating a new file, opening a
file, writing data to a file, reading data from a file, truncating a file, renaming, moving,
and copying a file, changing the access permissions and attributes of a file, closing a
file, deleting a file.

Along with other file functionalities available in the `Base` module of Julia, modules such
as `Filesystem` and `DelimitedFiles` are also provided in the standard library for
extensively working with files and performing other related file handling operations.

# File Handling On Text Files
A text file is data stored on a computer that is structured as a sequence of lines of
electronic text.

The "end of a line" and "end of a file" in a text file are usually denoted by end-of-line
and end-of-file delimiters, respectively. Whether these delimiters must be explicitly
specified when working with text files depends on the text editor and operating system in
use.

The term "text file" usually refers to a type of container that stores human-readable
characters. There are different formats of text files that serve different purposes, such as
plain text, document text, delimited text, etc.

!!! note "hint"
    To avoid creating unnecessary files while going through the examples, the `rm` function
    will be used to delete a file.

# Working On Document Texts
The most common type of document text is the text file with the `.txt` extension. A `.txt`
file is a simple text document that contains plain text with little to no formatting. It
can be opened and edited in any text-editing or word-processing program.

To demonstrate various parts of the file handling operations, an extensive example will be
conducted using the text document: https://www.gutenberg.org/cache/epub/228/pg228.txt.

### Creating a new file
In Julia, there are two main ways to create a new file: using the `open` function in
*creation* mode, and using the `touch` function.

The `open` function is typically used to create a file and work on it immediately, or
during the program's lifetime. The creation mode is activated with all keywords except
`read=true` and all string-based mode specifiers except `"r"` and `"r+"`. An example of
using the `open` function is:

```julia
io = open("The_Aeneid_by_Virgil.txt", create=true)

# do something with io

close(io)
```

or

```julia
open("The_Aeneid_by_Virgil.txt", create=true) do io
    # do something with io
end
```

This creates a file named `The_Aeneid_by_Virgil.txt` in your current working directory,
assigns the file handle to `io`, and closes it after the operations are completed.

The `touch` function is used when working with a file's timestamp and also provides a
convenient way to create a file. An example of using the `touch` function is:

```julia
touch("The_Aeneid_by_Virgil.txt")
```

This creates a file named `The_Aeneid_by_Virgil.txt` in the current working directory if it
does not already exist.

The location where a file is saved is important. The `Filesystem` module in the standard
library provides functionality for working with directories and paths. To create a file in
the current working directory, use the `touch` function. The `pwd` function can be used to
find the current working directory. For example:

```julia
julia> pwd()
"/Users/JuliaUser"

julia> touch("The_Aeneid_by_Virgil.txt")
"The_Aeneid_by_Virgil.txt"

julia> isfile("/Users/JuliaUser/The_Aeneid_by_Virgil.txt")
true

julia> rm("The_Aeneid_by_Virgil.txt")
```

To create a file in a different directory, either specify the directory while creating the
file or temporarily change the current working directory with `cd`. For example:

```julia
julia> touch("/Users/JuliaUser/Documents/The_Aeneid_by_Virgil.txt")
"/Users/JuliaUser/Documents/The_Aeneid_by_Virgil.txt"
```

or

```julia
julia> cd("/Users/JuliaUser/Documents") do
    touch("The_Aeneid_by_Virgil.txt")
end
```

We can verify this file as being in the `Documents` directory using the `isfile` function:

```julia
julia> isfile("Documents/The_Aeneid_by_Virgil.txt")
true

julia> rm("Documents/The_Aeneid_by_Virgil.txt")
```

To create a file in a new directory, use the `mkdir` or `mkpath` function. For example:

```julia
julia> mkdir("Project_Gutenberg_eBook")
"Project_Gutenberg_eBook"

julia> touch("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")
"Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt"

julia> isfile("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")
true
```

### Opening a file
Of course, we open files to work on them, so this is straightforward: `open` must be used
with a mode in mind, i.e., what we want to do with the file. If a mode is not specified, the
file is opened in a reading mode. See open in the `help?>` mode for available mode
specifiers.

### Writing to a file
When we want to write to a file, there are two ways to approach it, depending on the data:
If the data we want does not exist, we manually create it using the available writing
methods. On the other hand, if the data already exists, either in our computer or in an
outside source, we open or download it into our file, respectively, and write to it.

To manually write to a file, we open it in a writing mode (available mode specifiers can be
found using `open` in `help?>`) and then use `write` to write data to the file. The returned
value from `write` is the number of bytes written to the stream. For example:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "w") do io
           write(io, "This is an ebook")
       end
16
```

We can also write multiple words in a single call:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "w") do io
           write(io, "It was released in 1995,", " in USA.")
       end
32
```

Note that when using `open` with the mode specified as `"w"` or `"w+,"` the file size is
truncated to `0`, deleting all existing data in the file, and sets the stream position to
`1`.

`"r+"` when used with `open` does not truncate the file size, but it sets the stream
position to `1`, and any writing operations performed will override some or all of the
previous content in the file, depending on the length of the written text.

To open a file with the stream position at the end, use one of the append mode specifiers,
such as `"a"` or `"a+"`. For example, either of the following codes will write to the end of
the file or to a new line, respectively:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "a") do io
           write(io, " This is a nice book, and I'm glad to start reading it.")
       end
```

or

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "a") do io
           write(io, "\nThis is a nice book, and I'm glad to start reading it.")
       end
```

One can also check if a file is writable, before actually performing any writing operations
on it, by calling `iswritable`:

```julia
julia> file = open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "w");

julia> iswritable(file)
true

julia> file = open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "r");

julia> iswritable(file)
false

julia> rm("The_Aeneid_by_Virgil.txt")
```

In the real world, the data we want to work with often already exists on the internet. To
retrieve this data, we have to download it. Depending on the type of data, there are
different methods to do this. For a `.txt` file, the `Downloads` module, which is included
in the standard library, provides enough functionality. To use the `Downloads` module,
simply type `using Downloads`. With one line of code, we can download our poem into the
empty text file we created in the `Project_Gutenberg_eBook directory`:

```julia
julia> Downloads.download("https://www.gutenberg.org/cache/epub/228/pg228.txt", "Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt");
```

### Reading data from a file
Often, one may want to view the names of files in a directory or check if a file exists in a
given directory before accessing it. Julia provides the `readdir` function to return the
names of files in a directory:

```julia
julia> readdir("Project_Gutenberg_eBook")
1-element Vector{String}:
 "The_Aeneid_by_Virgil.txt"
```

When working with data in a file, we have to *read* it by opening the file in a
*reading mode*. To ensure the file is open in a read-only mode and prevent unexpected
modifications, use the `isreadonly` function:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           isreadonly(io)
       end
true

julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "r+") do io
           isreadonly(io)
       end
false
```

And we can also call `isreadable` to check if a file is readable before actually reading it:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "r+") do io
           isreadable(io)
       end
true

julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "a") do io
           isreadable(io)
       end
false
```

In Julia, there are several ways to read data from a file. To read all the data from a file
handle at once, you can use the `read` function. It's important to note that this method
"uses up" the file handle, meaning that it empties the stream after the reading operation is
complete:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           read(io) # file handle is read and rendered empty
           read(io) # file handle is empty already
       end
UInt8[]
```

To check if the end of a file (or stream) has been reached, and avoid reading into an empty
file, use the `eof` function.

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           read(io)
           if !eof(io)
               read(io) # io is already empty, so nothing is there to read
           end
       end
```

In Julia, there are different ways to read data from a file. Without passing a type as a
second argument to `read`, the data (i.e. the contents of the file) is read as bytes,
resulting in a `Vector{UInt8}` of the bytes read. For filling in the bytes read from a
stream into an array, see `read!` and `readbytes!`.

To read the contents of a file as a string, we pass `String` as a second argument to read:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           read(io, String)
       end
"\ufeffThe Project Gutenberg eBook of The Aeneid, by Virgil\r\n\r\nThis eBook is for the use of anyone anywhere in the United States and\r\nmost other parts of the world at no cost and with almost no restrictions\r\nwhatsoever. You may copy it, give it away or re-use it under the terms\r\nof the Pr" ⋯ 745969 bytes ⋯ " www.gutenberg.org\r\n\r\nThis website includes information about Project Gutenberg-tm,\r\nincluding how to make donations to the Project Gutenberg Literary\r\nArchive Foundation, how to help produce our new eBooks, and how to\r\nsubscribe to our email newsletter to hear about new eBooks.\r\n\r\n"
```

As seen above, the output includes all control characters. To print the data without these
characters, one can use `print` or `println`, as control characters are non-printing.

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           print(read(io, String))
       end
The Project Gutenberg eBook of The Aeneid, by Virgil

This eBook is for the use of anyone anywhere in the United States and
most other parts of the world at no cost and with almost no restrictions
 ⋮
including how to make donations to the Project Gutenberg Literary
Archive Foundation, how to help produce our new eBooks, and how to
subscribe to our email newsletter to hear about new eBooks.
```

The function `read(io, T)` reads the entire contents of a file in one call and returns an
object of type `T`:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           for i in read(io, Char)
               i == '\n' && break
               print(i)
           end
       end
T
```

To create an iterable object of type `T` from `read`ing a stream, use `readeach`:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           for i in readeach(io, Char)
               i == '\n' && break
               print(i)
           end
       end
The Project Gutenberg eBook of The Aeneid, by Virgil
```

To work with each byte of the stream (i.e. a single letter in our case), we use a `for` loop
to retrieve each byte:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           for (line_num, line) in enumerate(read(io, String))
               println("\$line_num. \$line")
               line_num == 5 && break
           end
       end
1. T
2. h
3. e
4.  
5. P
```

Most times, its actually a single line (not a single letter) we want to read from a file
handle; Julia provides the `readline` function for this:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           for line_num in 1:5
               print("\$line_num. ")
               println(readline(io))
           end
       end
1. The Project Gutenberg eBook of The Aeneid, by Virgil
2. 
3. This eBook is for the use of anyone anywhere in the United States and
4. most other parts of the world at no cost and with almost no restrictions
5. whatsoever. You may copy it, give it away or re-use it under the terms
```

Instead of going through a `for` loop to get each line of a file handle, we can use the
`readlines` function, which returns a vector with each element representing a line.

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           f = readlines("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")
           for (line_num, line) in enumerate(f[1:5])
               println("\$line_num. \$line")
           end
       end
1. The Project Gutenberg eBook of The Aeneid, by Virgil
2. 
3. This eBook is for the use of anyone anywhere in the United States and
4. most other parts of the world at no cost and with almost no restrictions
5. whatsoever. You may copy it, give it away or re-use it under the terms
```

There is also `eachline`, which, unlike `readlines`, creates a lazy iterable that yields
each line from an I/O stream or a file. For more information, see `eachline` in the `help?>`
mode:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           line_num = 1
           for line in eachline(io)
               println("\$line_num. \$line")
               line_num == 5 && break
               line_num += 1
           end
       end
1. The Project Gutenberg eBook of The Aeneid, by Virgil
2. 
3. This eBook is for the use of anyone anywhere in the United States and
4. most other parts of the world at no cost and with almost no restrictions
5. whatsoever. You may copy it, give it away or re-use it under the termss
```

One does not have to always start reading a file from the beginning, i.e. stream position
`1`. With `seek`, we can read the data from any desired valid position:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           seek(io, 56)
           line_num = 1
           for line in eachline(io)
               println("\$line_num. \$line")
               line_num == 5 && break
               line_num += 1
           end
       end
1. This eBook is for the use of anyone anywhere in the United States and
2. most other parts of the world at no cost and with almost no restrictions
3. whatsoever. You may copy it, give it away or re-use it under the terms
4. of the Project Gutenberg License included with this eBook or online at
5. www.gutenberg.org. If you are not located in the United States, you
```

There are also `seekstart` and `seekend`, which, as their names imply, seek a stream to its
start or end position, respectively. Other reading operations can be performed using
`readchomp`, `readuntil`, `skipchars`, and `readlink`.

### Truncating a file
"Truncating" a file means discarding all or some of its contents. Julia provides the
`truncate` function to perform this operation. It takes two arguments: the name of the file
to be truncated and the size to which it should be truncated.

Before truncating, let's check the number of bytes in the
`Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt` file:

```julia
julia> filesize("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")
731669
```

One thing to note is that when using `truncate`, it is important to open the file with the
mode set as `"a"` or `"a+"`, so that the stream position is set to the end of the file. For
example, to truncate to half the size of the file, use:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt", "a") do io
           truncate(io, filesize(io) ÷ 2)
       end
IOStream(<file Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt>)

julia> filesize("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")
365835
```

Open the `The_Aeneid_by_Virgil.txt` file in your text editor and see how the file has
been truncated.

### Renaming, moving & copying a file
To move and copy a file in Julia, we use the functions mv and cp, respectively. To rename a
file, we also use `mv`. As an example, we can rename our file from
`The_Aeneid_by_Virgil.txt` to `ebook.txt` and back to `The_Aeneid_by_Virgil.txt` as shown
below:

```julia
julia> readdir("Project_Gutenberg_eBook")
1-element Vector{String}:
 "The_Aeneid_by_Virgil.txt"

julia> mv("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt",
          "Project_Gutenberg_eBook/ebook.txt");

julia> readdir("Project_Gutenberg_eBook")
1-element Vector{String}:
 "ebook.txt"

julia> mv("Project_Gutenberg_eBook/ebook.txt",
          "Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt");
 
julia> readdir("Project_Gutenberg_eBook")
1-element Vector{String}:
 "The_Aeneid_by_Virgil.txt"
```

To move the file `The_Aeneid_by_Virgil.txt` from the `Project_Gutenberg_eBook` directory to
a new directory named `new_directory1`, we use `mv`:

```julia
julia> readdir("Project_Gutenberg_eBook")
1-element Vector{String}:
 "The_Aeneid_by_Virgil.txt"

julia> mkdir("new_directory1")
"new_directory1"

julia> mv("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt",
          "/Users/JuliaUser/new_directory1/new_file.txt")
"/Users/JuliaUser/new_directory1/new_file.txt"

julia> readdir("Project_Gutenberg_eBook")
String[]

julia> readdir("new_directory1")
1-element Vector{String}:
 "new_file.txt"
```

And we can copy the file from `new_directory1` to `Project_Gutenberg_eBook` using `cp`:

```julia
julia> cp("/Users/udohjeremiah/new_directory1/new_file.txt",
          "Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")
"Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt"

julia> readdir("Project_Gutenberg_eBook")
1-element Vector{String}:
 "The_Aeneid_by_Virgil.txt"

julia> readdir("new_directory1")
1-element Vector{String}:
 "new_file.txt"

julia> rm("/Users/JuliaUser/new_directory1", recursive=true)
```

For more information, see `mv` and `cp` in `help?>`.

### changing the access permissions and attributes of a file
chmod
chown

### Closing a file
Files are automatically closed when `open` is used with a `do` block:

```julia
julia> open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt") do io
           # do something
       end

julia> isopen(io)
ERROR: UndefVarError: io not defined
```

However, if `open` is used without a `do` block, the file must be manually closed using
`close`:

```julia
julia> io = open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt");

julia> isopen(io)
true

julia> close(io)

julia> isopen(io)
false
```

### Deleting a file
To delete a file, simply pass the filename or absolute path (if you're not in the file
directory) to `rm`:

```julia
julia> f = open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt");

julia> rm("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")

julia> f = open("Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt")
ERROR: SystemError: opening file "Project_Gutenberg_eBook/The_Aeneid_by_Virgil.txt": No such file or directory
```

For more information, see `rm` in `help?>`.

# Working On Delimited Texts
The most common type of delimited text is a text file with the `.csv` extension. A `.csv`
file is a simple delimited text file that is typically used for storing tabular data in
plain text, where each line has the same number of fields, separated into columns with
commas (`,`) and rows with newlines (`\n`). The use of a comma as a field separator is the
source of the name for this file format: comma-separated values (CSV).

Double quotes are used as escape characters in `.csv` files. A string with a comma can be
delimited by double quotes, so the comma is not misinterpreted as a field separator. To
de-escape a double quote, meaning to use it literally, two double quotes are used. A final,
unmatched, double quote on a line indicates that line continues on the next line. In most
cases, a `.csv` file may include an initial line of headers that provides information about
the data.

When you have small data stored in CSV format and it is homogenous in type, you may want to
avoid using external packages and instead use the `DelimitedFiles` module provided in the
standard library, which can be loaded by `using DelimitedFiles`.

!!! compat "Julia 1.9"
    The `DelimitedFiles` module has been separated from the standard library and must now be
    explicitly installed for use.

The `DelimitedFiles` module provides only two functions, `readdlm` and `writedlm`, for
reading and writing delimited files, respectively. We'll demonstrate the use of `readdlm`
and `writedlm` using a file, https://people.sc.fsu.edu/~jburkardt/data/csv/homes.csv, that
contains the home sale statistics of 50 homes. Each row in the file includes the selling
price, asking price, living space, rooms, bedrooms, bathrooms, age, acreage, and taxes.

To load and save the `home.csv` file from the internet to our file system, we use the
`download` function provided by the `Downloads` module.

```julia
julia> using Downloads

julia> Downloads.download("https://people.sc.fsu.edu/~jburkardt/data/csv/homes.csv", "homes.csv")
"homes.csv"
```

To ensure that there are no empty rows after the last row in the `homes.csv` file
(which can cause an error when converting to a type other than String), we use `readlines`:

```julia
julia> open(io -> show(readlines(io)[end]), "homes.csv")
" "
```

As seen above, there is an additional irrelevant row in `homes.csv`. To remove it, we use
`truncate`:

```julia
julia> open("homes.csv", "a") do io
           truncate(io, filesize(io) - 3)
       end;

julia> open(io -> length(readlines(io)), "homes.csv")
51

julia> open(io -> show(readlines(io)[end]), "homes.csv")
"133, 145, 26,  7, 3, 1,  42, 0.36,  3059"
```

The `readdlm` function can have different argument specifications (see `readdlm` in `help?>`
for more information). Our example demonstrates its usage by using the `header` keyword
argument, as the `homes.csv` file contains an initial header line. To call `readdlm` on the
`homes.csv` file, we use the following code:

```julia
julia> data, headers = readdlm("homes.csv", ',', Float64, '\n', dims=(51, 9), header=true);
```

This code results in two variables, one with the headers of the data and the other with the
data itself.

```julia 
julia> headers
1×9 Matrix{AbstractString}:
 "Sell"  " \"List\""  " \"Living\""  …  " \"Acres\""  " \"Taxes\""

julia> data
50×9 Matrix{Float64}:
 142.0  160.0  28.0  10.0  5.0  3.0   60.0  0.28  3167.0
 175.0  180.0  18.0   8.0  4.0  1.0   12.0  0.43  4033.0
 129.0  132.0  13.0   6.0  3.0  1.0   41.0  0.33  1471.0
 138.0  140.0  17.0   7.0  3.0  1.0   22.0  0.46  3204.0
 232.0  240.0  25.0   8.0  4.0  3.0    5.0  2.05  3613.0
   ⋮                            ⋮                 
 129.0  135.0  10.0   6.0  3.0  1.0   15.0  1.0   2438.0
 143.0  145.0  21.0   7.0  4.0  2.0   10.0  1.2   3529.0
 247.0  252.0  29.0   9.0  4.0  2.0    4.0  1.25  4626.0
 111.0  120.0  15.0   8.0  3.0  1.0   97.0  1.11  3205.0
 133.0  145.0  26.0   7.0  3.0  1.0   42.0  0.36  3059.0
```

If for some reason you do not need the initial header (if the file has one), then use the
`skipstart` keyword:

```julia
julia> data = readdlm("homes.csv", ',', Float64, '\n', dims=(50, 9), skipstart=1);

julia> data
50×9 Matrix{Float64}:
 142.0  160.0  28.0  10.0  5.0  3.0   60.0  0.28  3167.0
 175.0  180.0  18.0   8.0  4.0  1.0   12.0  0.43  4033.0
 129.0  132.0  13.0   6.0  3.0  1.0   41.0  0.33  1471.0
 138.0  140.0  17.0   7.0  3.0  1.0   22.0  0.46  3204.0
 232.0  240.0  25.0   8.0  4.0  3.0    5.0  2.05  3613.0
   ⋮                            ⋮                 
 129.0  135.0  10.0   6.0  3.0  1.0   15.0  1.0   2438.0
 143.0  145.0  21.0   7.0  4.0  2.0   10.0  1.2   3529.0
 247.0  252.0  29.0   9.0  4.0  2.0    4.0  1.25  4626.0
 111.0  120.0  15.0   8.0  3.0  1.0   97.0  1.11  3205.0
 133.0  145.0  26.0   7.0  3.0  1.0   42.0  0.36  3059.0
```

However, note that setting `header=true` and `skipstart=1` removes the first row of the
data, which is often the initial header, and sets the header to the row following the first
row:

```julia
julia> data, header = readdlm("homes.csv", ',', Float64, '\n', dims=(50, 9), skipstart=1, header=true);

julia> header
1×9 Matrix{AbstractString}:
 "142"  " 160"  " 28"  " 10"  " 5"  " 3"  "  60"  " 0.28"  "  3167"

julia> data
49×9 Matrix{Float64}:
 175.0  180.0  18.0   8.0  4.0  1.0   12.0  0.43  4033.0
 129.0  132.0  13.0   6.0  3.0  1.0   41.0  0.33  1471.0
 138.0  140.0  17.0   7.0  3.0  1.0   22.0  0.46  3204.0
 232.0  240.0  25.0   8.0  4.0  3.0    5.0  2.05  3613.0
 135.0  140.0  18.0   7.0  4.0  3.0    9.0  0.57  3028.0
   ⋮                            ⋮                 
 129.0  135.0  10.0   6.0  3.0  1.0   15.0  1.0   2438.0
 143.0  145.0  21.0   7.0  4.0  2.0   10.0  1.2   3529.0
 247.0  252.0  29.0   9.0  4.0  2.0    4.0  1.25  4626.0
 111.0  120.0  15.0   8.0  3.0  1.0   97.0  1.11  3205.0
 133.0  145.0  26.0   7.0  3.0  1.0   42.0  0.36  3059.0
```

Now, assuming that for our purposes the headers are not descriptive enough, we can change
them by using `writedlm`. However, note that there is no "insert mode" for writing to a file
stream. One cannot write to the beginning of a file without overwriting the previous
content. The best solution is to use a queue:

```julia
julia> data = readdlm("homes.csv", ',', Any, '\n', dims=(50, 9), skipstart=1);

julia> head  = ["sell price", "ask price", "living space", "total rooms",
                "bedrooms", "bathrooms", "age", "acreage", "taxes"];

julia> open("homes.csv", "w") do io
           f = vcat(hcat(head...), data)
           writedlm(io, f, ',')
       end
```

With the above operations, our file has been updated, and we can observe the new headers it
now has:

```julia
julia> data, headers = readdlm("homes.csv", ',', header=true);

julia> headers
1×9 Matrix{AbstractString}:
 "sell price"  "ask price"  "living space"  …  "age"  "acreage"  "taxes"
```

A list of packages in the Julia ecosystem that may provide better functionality than
`DelimitedFiles` for large files with heterogeneous types can be found
[JuliaData](https://github.com/JuliaData), [JuliaIO](https://github.com/JuliaIO) and
other related packages that can be searched for on
[Julia Packages](https://juliapackages.com).

Aside from regular files and directories, Julia also provides a rich interface for dealing
with special file streaming I/O objects, such as terminals, pipes, and TCP sockets.
"""
function files()
    header1 = "Constants"
    printstyled(header1, '\n', '≡'^(length(header1) + 2), '\n'; bold=true);
    println("""
    ENDIAN_BOM    PROGRAM_FILE\n""")

    header2 = "Macros"
    printstyled(header2, '\n', '≡'^(length(header2) + 2), '\n'; bold=true);
    println("""
    @__DIR__    @__FILE__    @isdefined    @less\n""")

    header3 = "General Types & Constructors"
    printstyled(header3, '\n', '≡'^(length(header3) + 2), '\n'; bold=true);
    println("""
    AbstractDisplay    IOBuffer     LibuvStream    SecretBuffer
    AbstractPipe       IOContext    Pipe           TextDisplay
    IO                 IOStream     PipeBuffer\n""")

    header4 = "File Info Functions"
    printstyled(header4, '\n', '≡'^(length(header4) + 2), '\n'; bold=true);
    println("""
    close         cp          ctime       filemode    lstat    stat
    closewrite    eachline    diskstat    filesize    mtime\n""")

    header5 = "File Handling Operations"
    printstyled(header5, '\n', '≡'^(length(header5) + 2), '\n'; bold=true);
    println("""
    close         mv            read!            readeach     rm
    closewrite    open          readavailable    readline     touch
    cp            open_flags    readbytes!       readlines    truncate
    eachline      read          readchomp        readuntil    write\n""")

    header6 = "Working With Directories"
    printstyled(header6, '\n', '≡'^(length(header6) + 2), '\n'; bold=true);
    println("""
    cd         gethostname    mkdir        pwd        splitdir    walkdir
    dirname    homedir        mktempdir    readdir    tempdir\n""")

    header7 = "Working With File Paths"
    printstyled(header7, '\n', '≡'^(length(header7) + 2), '\n'; bold=true);
    println("""
    abspath         expanduser    mkpath      readlink    splitdrive    symlink
    basename        hardlink      mktemp      realpath    splitext      tempname
    contractuser    joinpath      normpath    relpath     splitpath\n""")

    header8 = "Working With Modules Paths"
    printstyled(header8, '\n', '≡'^(length(header8) + 2), '\n'; bold=true);
    println("""
    evalfile    include    include_dependency    include_string    pathof\n""")

    header9 = "Working With File Permissions"
    printstyled(header9, '\n', '≡'^(length(header9) + 2), '\n'; bold=true);
    println("""
    chmod    chown    gperm    operm    uperm\n""")

    header10 = "Working With Stream Position"
    printstyled(header10, '\n', '≡'^(length(header10) + 2), '\n'; bold=true);
    println("""
    peek        reset    seekstart    skip    unmark
    position    seek     seekend      mark\n""")

    header11 = "True/False Functions"
    printstyled(header11, '\n', '≡'^(length(header11) + 2), '\n'; bold=true);
    println("""
    eof           isdefined    islink           isopen        issetuid
    isa           isdir        ismarked         ispath        issocket
    isabspath     isdirpath    ismount          isreadable    issticky
    isblockdev    isfifo       ismutable        isreadonly    isstructtype
    ischardev     isfile       ismutabletype    issetgid      iswritable\n""")

    header12 = "General Functions"
    printstyled(header12, '\n', '≡'^(length(header12) + 2), '\n'; bold=true);
    println("""
    bytesavailable    ltoh               showerror     summarysize
    countlines        methods            skipchars     take!
    displaysize       methodswith        sprint        typeintersect
    download          ntoh               subtypes      typejoin
    fd                pipeline           supertype     typeof
    fdio              redirect_stderr    supertypes    unsafe_read
    flush             redirect_stdin     stderr        unsafe_write
    htol              redirect_stdio     stdin
    hton              redirect_stdout    stdout
    less              show               summary\n""")
end