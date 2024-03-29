def compile(filename, folder = "assembly")
  file "#{filename}.o" => ["#{folder}/#{filename}.asm"] do
    `nasm -i macros/ -i headers/ -O1 -f macho #{folder}/#{filename}.asm -o #{filename}.o`
  end
end

def compile_test(filename)
  compile(filename, "tests")
end

def link_binary(filename, dependencies)
  file filename => dependencies do
    `ld -no_pie                  \
        -macosx_version_min 10.6 \
        -arch i386               \
        -e main                  \
        -o #{filename}           \
        #{dependencies.join(' ')}`
  end
end

def test_filenames
  Binaries.map(&:first).select{ |filename| filename.end_with? "test" }
end

def non_test_filenames
  Binaries.map(&:first).select{ |filename| !filename.end_with? "test" }
end

def silent_rm(files)
  `rm #{files} 2> /dev/null`
end

compile "board"
compile "command_line"
compile "command_line_ui"
compile "negamax"
compile "system"
compile "tictactoe"

compile_test "board_test"
compile_test "command_line_test"
compile_test "negamax_test"
compile_test "tictactoe_test"

Binaries = [
  ["board_test",        %w[board_test.o system.o board.o]],
  ["command_line_test", %w[command_line_test.o system.o board.o negamax.o command_line.o]],
  ["negamax_test",      %w[negamax_test.o system.o board.o negamax.o]],
  ["tictactoe_test",    %w[tictactoe_test.o tictactoe.o system.o board.o]],
  ["tictactoe",         %w[tictactoe.o board.o]],
  ["command_line_ui",   %w[command_line_ui.o tictactoe.o board.o system.o command_line.o negamax.o]]
]

Binaries.each do |filename, dependecies|
  link_binary filename, dependecies
end

task :default => ["play"]

namespace "clean" do
  desc "Delete .o files"
  task "objects" do
    silent_rm "*.o"
  end

  desc "Delete test binaries"
  task "test" => ["clean:objects"] do
    silent_rm test_filenames.join(' ')
  end

  desc "Delete non-test binaries"
  task "binaries" do
    silent_rm non_test_filenames.join(' ')
  end

  desc "Delete all binaries and .o files"
  task "all" => ["clean:objects", "clean:test", "clean:binaries"]
end

desc "Compile and run the test suite"
task "test" => ["command_line_test", "board_test", "negamax_test", "tictactoe_test"] do
  system test_filenames.map{ |filename| "./" + filename }.join(" && ")
  Rake::Task["clean:test"].invoke
end

desc "Compile the game and run it"
task "play" => ["command_line_ui"] do
  system "./command_line_ui"
  Rake::Task["clean:objects"].invoke
  `rm command_line_ui`
end
