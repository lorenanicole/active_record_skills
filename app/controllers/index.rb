get '/' do
  @all_proficiencies = Proficiency.all
  # @all_users = Users.all
  # @all_skills_for_user = User.skills.all
  # render home page

  erb :index
end

#----------- SESSIONS -----------

get '/sessions/new' do
  # render sign-in page
  @email = nil
  erb :sign_in
end

post '/sessions' do
  # sign-in
  @email = params[:email]
  user = User.authenticate(@email, params[:password])
  if user
    # successfully authenticated; set up session and redirect
    session[:user_id] = user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-in form, displaying an error
    @error = "Invalid email or password."
    erb :sign_in
  end
end

delete '/sessions/:id' do
  # sign-out -- invoked via AJAX
  return 401 unless params[:id].to_i == session[:user_id].to_i
  session.clear
  200
end


#----------- USERS -----------

get '/users/new' do
  # render sign-up page
  @user = User.new
  erb :sign_up
end

post '/users' do
  # sign-up
  @user = User.new params[:user]
  if @user.save
    # successfully created new account; set up the session and redirect
    session[:user_id] = @user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-up form, displaying errors
    erb :sign_up
  end
end
#----------- SKILLS -----------

get '/add_skill' do
  erb :add_skill
end

post '/add_skill' do
  user = session[:user_id]
  @skill = Skill.create(name: params[:name], context: params[:context])
  formal_training = params[:formal_training]
  puts "#{formal_training == "true"}"
  Proficiency.create(user_id: user, skill_id: @skill.id, years_experience: params[:years_experience].to_i,
    formal_training: formal_training == "true")
  erb :add_skill
end

get '/myskills' do
  user = session[:user_id]
  @all_skills = User.find(user).skills
  erb :my_skills
end


get '/editskill/:skill_id' do
  @skill = Skill.find(params[:skill_id])
  @proficiency = Proficiency.where(skill_id: @skill, user_id: session[:user_id]).first
  erb :edit_skill
end

post '/editskill/:skill_id' do
  skill = Skill.find(params[:skill_id])
  skill.update_attributes(name: params[:name], context: params[:context])
  formal_training = params[:formal_training]
  proficiency = Proficiency.where(skill_id: skill, user_id: session[:user_id]).first
  proficiency.update_attributes(years_experience: params[:years_experience].to_i,
    formal_training: formal_training == "true")
  redirect('/myskills')
end












