require "csv"

@students = [] # an empty array accessible to all methods
@filename = ""

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list of students"
  puts "4. Load the list of students"
  puts "5. Show students by cohort"
  puts "9. Exit"
end

def add_students_to_list(name, cohort)
  cohort = cohort.to_sym
  @students << {name: name, cohort: cohort}
end

def input_students
  puts "To finish, just hit return twice"
  while true do
    puts "Please insert the student's name"
    name = STDIN.gets.strip
    break if name.empty?
    puts "Please insert the student's cohort"
    cohort = STDIN.gets.strip
    cohort = "Unknown" if cohort.empty?
    add_students_to_list(name, cohort)
    puts @students.count == 1 ? "Now we have #{@students.count} student" : "Now we have #{@students.count} students"
  end
  puts "Good job on introducing the students!"
end

def print_header
  puts "The students of Villains Academy".center(100)
  puts "-------------".center(100)
end

def print_students_list
  i = 0
  @students.each do |student|
    puts "#{i+1}.  #{student[:name]} (#{student[:cohort]} cohort)".center(100)
    i += 1
  end
end

def print_grouped_by_cohort
  cohorts = @students.map {|student| student[:cohort]}
  cohorts.uniq.each do |cohort|
    puts cohort
    @students.each {|student| puts student[:name] if student[:cohort] == cohort}
  end
end

def print_footer
  count = @students.count
  puts "Overall, we have #{count} great student".center(100) if count == 1
  puts "Overall, we have #{count} great students".center(100) if count > 1
end

def show_students
  print_header
  print_students_list
  print_footer
end

def select_file
  puts "Please choose a file to save to/load from"
  @filename = STDIN.gets.strip
  @filename = "students.csv" if @filename.empty?
end

def save_students
  CSV.open(@filename, "w") do |file| # open the file for writing
    @students.each do |student| # iterate over the array of students
      student_data = [student[:name], student[:cohort]]
      file << student_data
    end
  end
  puts "#{@students.count} students have been saved to #{@filename}"
end

def load_students
  CSV.foreach(@filename) do |line|
    name, cohort = line
    add_students_to_list(name, cohort)
  end
  puts "#{@students.length} students have been loaded from #{@filename}"
end

def try_load_students #this loads the students from the file right at the beginning of the program
  @filename = ARGV.first
  @filename = "students.csv" if @filename == nil
  load_students(@filename)
  puts "Loaded #{@students.count} students from #{@filename}"
end

def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    select_file
    save_students
  when "4"
    select_file
    load_students(@filename)
  when "5"
    print_grouped_by_cohort
  when "9"
    puts "Bye!"
    exit
  else
    puts "I don't know what you mean, try again"
  end
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

try_load_students
interactive_menu
