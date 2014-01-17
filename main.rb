class My_db
  
  def initialize
    @data = Hash.new("NULL")
    @index = Hash.new(0)
    @terminate = false
    @operation_stack = []
    
    run
  end
  
  def run
    while !@terminate
      puts "Please input operation :"
      operate
    end
  end
  
  def operate(cammand = gets.chomp)
    operation, key, value = cammand.split(" ")
    operation = operation.downcase.to_sym
    
    if value
       self.send(operation, key, value)
    elsif key
       self.send(operation, key)
    else
       self.send(operation)
    end
  end
  
  def get(key)
    @data[key]
    puts @data[key]
  end
  
  def set(key, value)
    record_change(key)
    @index[@data[key]] -= 1 if @data[key] != "NULL"
    @data[key] = value
    @index[value] += 1
  end
  
  def unset(key)
    record_change(key)
    @index[@data[key]] -= 1 if @data[key] != "NULL"
    @data[key] = "NULL"
  end
  
  def numequalto(value)
    count = @index[value]
    puts count
  end
  
  def record_change(key)
    if @operation_stack.length > 0
      @operation_stack << ("SET " + key + " " + @data[key])
    end
  end
  
  def begin
    @operation_stack << "begin"
  end

  def rollback
    reverse_operation = @operation_stack.pop
    while reverse_operation != "begin" do
      operate(reverse_operation)
      @operation_stack.pop
      reverse_operation = @operation_stack.pop
    end
  end

  def commit
    @operation_stack = []
  end
  
  def end
    @terminate = true
    puts "bye"
  end
  
end

My_db.new
