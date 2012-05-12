def compile(filename)
  file "#{filename}.o" => ["assembly/#{filename}.asm"] do
    `nasm -i macros/ -i headers/ -O1 -f macho assembly/#{filename}.asm -o #{filename}.o`
  end
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

compile "ai"
compile "board"
compile "board_test"
compile "command_line"
compile "command_line_test"
compile "main"
compile "negamax"
compile "negamax_test"
compile "system"
compile "tictactoe"
compile "tictactoe_test"

Binaries = [
  ["ai",                %w[ai.o command_line.o system.o board.o negamax.o]],
  ["board_test",        %w[board_test.o system.o board.o]],
  ["command_line_test", %w[command_line_test.o system.o board.o negamax.o command_line.o]],
  ["negamax_test",      %w[negamax_test.o system.o board.o negamax.o]],
  ["tictactoe_test",    %w[tictactoe_test.o tictactoe.o system.o board.o]],
  ["tictactoe",         %w[tictactoe.o board.o]],
  ["main",              %w[main.o tictactoe.o board.o system.o command_line.o negamax.o]]
]

Binaries.each do |filename, dependecies|
  link_binary filename, dependecies
end

task :default => ["play"]

namespace "clean" do
  task "objects" do
    silent_rm "*.o"
  end

  task "test" => ["clean:objects"] do
    silent_rm test_filenames.join(' ')
  end

  task "binaries" do
    silent_rm non_test_filenames.join(' ')
  end

  task "all" => ["clean:objects", "clean:test", "clean:binaries"]
end

task "test" => ["command_line_test", "board_test", "negamax_test", "tictactoe_test"] do
  system test_filenames.map{ |filename| "./" + filename }.join(" && ")
  Rake::Task["clean:test"].invoke
end

task "play" => ["main"] do
  system "./main"
  Rake::Task["clean:objects"].invoke
  `rm main`
end
