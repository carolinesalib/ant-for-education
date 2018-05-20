class Solution
  attr_accessor :timeslots_teachers

  def initialize(problem)
    @problem = problem
  end

  # TODO:
  # criar o init event_teachers
  # calcular hard constraints
  #   - carga horária do professor
  #   - ele não pode ta em dois timeslots iguais ao mesmo tempo
  #   - não ter dois professores diferentes para a mesma disciplinas em uma mesma classe


  def assign_teachers
    @problem.timeslots.size.times do |timeslot|
      @problem.events.size.times do |event|
        event_index = timeslots_teachers[timeslot][event]

        return if event_index.nil?

        event = @problem.events[event_index]

        unless event.teacher.present?
          event.teacher = TeacherDiscipline.where(discipline_id: event.discipline_id).first.teacher
        end
      end
    end
  end


  def hard_constraints_violations
    hard_constraints_violations = 0

    @problem.timeslots.size.times do |timeslot_index|
      events = timeslots_teachers[timeslot_index]
      teachers = []
      events.each do |event_index|
        teachers << @problem.events[event_index].teacher.id if @problem.events[event_index].teacher.present?
      end

      hard_constraints_violations += 1 if teachers.uniq.size < events.size
    end

    hard_constraints_violations
  end

  def compute_feasibility
    # a professor can not be in the same timeslot more than one time
    @problem.timeslots.size.times do |timeslot_index|
      events = timeslots_teachers[timeslot_index]
      teachers = []
      events.each do |event_index|
        teachers << @problem.events[event_index].teacher.id if @problem.events[event_index].teacher.present?
      end

      return false if teachers.uniq.size < events.size
    end

    # each class must have all the timeslots allocated
    @problem.timeslots.size.times do |timeslot_index|
      classrooms = []
      @problem.timeslots_events[timeslot_index].size.times do |event_index|
        classrooms << @problem.events[event_index].lesson.classroom.id
      end

      return false if classrooms.uniq.size < classrooms.size
    end

    true
  end
end