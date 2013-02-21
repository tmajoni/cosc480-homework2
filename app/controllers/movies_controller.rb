# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
    sorting = params[:sort] || session[:sort]
   
   #  @movies = Movie.all
    if  params['sort'] == 'title'
	order = {:order => :title}
        # @movies = @movies.order('title')
    	 @title_header = 'hilite'
    end
    if params['sort'] == 'release_date'
	order = {:order => :release_date}
	#@movies = @movies.order('release_date')
    	@date_header = 'hilite'
     end
    @all_ratings = Movie.all_ratings
    @my_ratings = params[:ratings] ||session[:ratings] || {}

     if @my_ratings.nil? 
	@my_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
#    if !params[:ratings].nil?
#        @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
#	params[:ratings].each_key do |key|
#	@my_ratings << key
        
#	@movies = Movie.find_all_by_rating(@my_ratings)
	end
#    elsif
#	@my_ratings = @all_ratings
     if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
        session[:sort] = sorting
	session[:ratings] = @my_ratings
	redirect_to :sort => sorting, :ratings => @my_ratings and return
     end	
	
      @movies = Movie.find_all_by_rating(@my_ratings.keys, order) 
      
 end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
