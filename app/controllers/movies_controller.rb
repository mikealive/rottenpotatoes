class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort, :ratings)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def defrating
    @all_ratings=['G','PG','PG-13','R']
    @all_ratings
  end

  def index
    @all_ratings=defrating
    @keys=[nil]
    if(params[:ratings]!=nil)
      rating=params[:ratings]
      session[:ratings]=rating
      session[:sort]=nil
    elsif(session[:ratings]!=nil && params[:sort]==nil)   #have to be && to avoid mess
      rating=session[:ratings]
      flash.keep
      redirect_to movies_path(:ratings=>rating)
    else
      rating=nil
    end
    if(params[:sort]!=nil)
      sort=params[:sort]
      session[:sort]=sort
      session[:ratings]=nil
    elsif(session[:sort]!=nil && params[:ratings]==nil)
      sort=session[:sort]
      flash.keep
      redirect_to movies_path(:sort=>sort)
    else
      sort=nil
    end
    if(sort=='title' || sort=='release_date')
      @movies = Movie.order(sort)
      @sort=sort;
    elsif(rating.nil?)
      @movies = Movie.all
    else
      keys=rating.keys
      @keys=keys
      @movies = Movie.where(rating: keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
