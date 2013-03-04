class TeacherStatCalc
  class Stat
    attr_accessor :type, :correct, :attempted, :user_count
    
    def initialize(problem_type)
      @type = problem_type
      @correct = @attempted = @user_count = 0
    end

    def percent
      @attempted == 0 ? "" : (@correct * 100.0/@attempted).to_i.to_s
    end

    def attempted_percent
      # brackets contains the progressive arrays indicating the number of people required
      # to reach a specific percent
      brackets = [
        [25.0, 0.2],   # 25 students * 1 question => 20%
        [100.0, 0.5],  # 25 students * 4 questions
        [300.0, 0.75], # 25 students * 12 questions
        [1000.0, 0.9], # 25 students * 40 questions
        [2500.0, 1],   # 25 students * 100 questions
        [Float::MAX, 1],   # break the loop
      ]

      a = attempted
      ret = [a, brackets[0][0]].max * 0.8
      while a > brackets[1][0] 
        prev_b = brackets.shift
        next_b = brackets[0]
        
        uncounted = a - prev_b[0]
        b_max     = next_b[0] - prev_b[0][0] 
        b_percent = next_b[1] - prev_b[0][1] 

        ret += b_percent * [uncounted, b_max].max / b_max

        brackets.shift
      end

      ret
    end

    def to_s 
      "<Stat: #{@type.to_s}, #{@correct}, #{@attempted}, #{@user_count}>"
    end
  end

  def initialize(students = [], problem_types = [])
    @students = students
    @problem_types = problem_types

    if @problem_types.empty? || @students.empty?
      @student_stats = []
      @concept_progress = []
    end
  end

  def class_size
    @students.length
  end


  def student_stats
    @student_stats ||= ProblemStat.where(:problem_type_id => @problem_types.map(&:id),
                                         :user_id => @students.map(&:id)).includes(:problem_type)
  end

  def concept_progress
    return @concept_progress unless @concept_progress.nil?
    ptype_records = Hash[@problem_types.map { |p| [p.id, Stat.new(p)] }]

    $stderr.puts "FUUUU" * 20
    $stderr.puts "ptype_records: " + ptype_records.inspect
    $stderr.puts "problem_types: " + @problem_types.map { |p| [p, Stat.new(p)] }.inspect
    student_stats.each do |stat|
      $stderr.puts stat.inspect + stat.correct.to_s + " " + stat.count.to_s
      r = ptype_records[stat.problem_type_id]
      $stderr.puts "r = " + r.inspect

      r.correct    += stat.correct
      r.attempted  += stat.count
      r.user_count += 1
    end

    @concept_progress = ptype_records.values.sort { |r1, r2| smart_score(r1) <=> smart_score(r2) }
    $stderr.puts @concept_progress.inspect
    return @concept_progress
  end

  def attempted_max
    @attempted_max if !@attempted_max.nil?
    max = 0
    concept_progress.each { |stat| max = stat.attempted if stat.attempted > max }
    @attempted_max = max
  end

  def smart_score(r)
    (r.user_count + 3) * (r.correct + 1.0) / (r.attempted + 1.0)
  end
end
