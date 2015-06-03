class UsersController < ApplicationController
  PAGE_SIZE = 100

  def show
    @user = RubyStackoverflow.users_by_ids([params[:id]]).data.first
    render file: '/public/404', status: :not_found and return unless @user
    questions = RubyStackoverflow.users_questions([@user.user_id]).data.first
    @user.questions.concat(questions.try(:questions) || [])
    page = 0
    begin
      page += 1
      answers = RubyStackoverflow.users_with_answers(
        [@user.user_id],
        page: page,
        pagesize: PAGE_SIZE
      )
      @user.answers.concat(answers.data.first.try(:answers) || [])
    end while answers.has_more
    answer_ids = @user.answers.map(&:question_id)
    @answered = {}
    answer_ids.in_groups_of(PAGE_SIZE, false).each do |ids|
      answered_questions = RubyStackoverflow.questions_by_ids(
        ids, pagesize: PAGE_SIZE
      ).data
      @answered.merge!(answered_questions.index_by(&:question_id))
    end
  end
end
