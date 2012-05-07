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

compile "ai"
compile "board"
compile "board_test"
compile "command_line"
compile "command_line_test"
compile "negamax"
compile "negamax_test"
compile "system"
compile "tictactoe_test"

Binaries = [
  ["ai",                %w[ai.o command_line.o system.o board.o negamax.o]],
  ["board_test",        %w[board_test.o system.o board.o]],
  ["command_line_test", %w[command_line_test.o system.o board.o negamax.o command_line.o]],
  ["negamax_test",      %w[negamax_test.o system.o board.o negamax.o]],
  ["tictactoe_test",    %w[tictactoe_test.o system.o]]
]

Binaries.each do |filename, dependecies|
  link_binary filename, dependecies
end

task :default => ["ai", "clean"]

task "clean" do
  `rm *.o`
end

task "clean:test" => ["clean"] do
  `rm #{test_filenames.join(' ')}`
end

task "clean:all" => ["clean", "clean:test"] do
  `rm ai`
end

task "test" => ["command_line_test", "board_test", "negamax_test", "tictactoe_test"] do
  system test_filenames.map{ |filename| "./" + filename }.join(" && ")
  Rake::Task["clean:test"].invoke
end
