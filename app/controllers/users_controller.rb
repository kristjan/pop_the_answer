class UsersController < ApplicationController
  def show
    @user = RubyStackoverflow.users_by_ids([params[:id]]).data.first
    render file: '/public/404', status: :not_found and return unless @user
    questions = RubyStackoverflow.users_questions([@user.user_id]).data.first
    @questions = questions.try(:questions) || []
    answers = RubyStackoverflow.users_with_answers([@user.user_id]).data.first
    @answers = answers.try(:answers) || []
    answer_ids = @user.answers.map(&:id)
    @answered = {}
    if answer_ids.any?
      @answered = RubyStackoverflow.questions_by_ids(answer_ids).index_by(&:id)
    end
  end
end
