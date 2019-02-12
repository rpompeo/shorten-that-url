class UrlsController < ApplicationController
    before_action :authenticate_admin!, :only => [:index]
    
    def new
        @url = Url.new
    end

    def create
        #require 'pry'; binding.pry
        target = params[:url][:target]
        target = "http://" + target if target[0..3] != "http"
        # if url includes current domain name, then redirect to homepage with error message
        if target.include? request.base_url
            flash[:danger] = "Sorry, you can\'t shorten a url from this domain!!!"
            redirect_to new_url_path
        else
            url = Url.find_by(target: target) #lookup the target url to see if it exists in the DB already
            #if url exists, redirect to the url page ionstead of creating a new url record
            if url
                url.update_attribute(:clicks, (url.clicks || 0)+1) if url
                flash[:success] = "Your Target url has been shortened successfully"
                redirect_to url_path(url)
            else
                # else create a new url record
                new_url = Url.new(target: target)
                slug = SecureRandom.hex(1)
                found_slug = Url.find_by(slug: slug)
                found_slug.update_attribute(:active, false) if found_slug
                new_url.slug = slug
                new_url.clicks = 1;
                new_url.active = true
                if new_url.save
                    flash[:success] = "Your Target url has been shortened successfully"
                    redirect_to url_path(new_url.id)
                else
                    flash[:danger] = "Unable to shorten Url"
                    redirect_to root_path
                end
            end
        end
    end

    def show
        @url = Url.find(params[:id])
    end

    def retrieve
    end

    def retrieve_slug
        short_url = params[:url][:short_url]
        short_url = "http://" + short_url if short_url[0..3] != "http"
        slug = short_url.split("/").last
        url = Url.find_by(slug: slug)
        if url
            flash[:success] = "Your Shortened url has been retrieved successfully"
            redirect_to url_path(url)
        else
            flash[:danger] = "Sorry, this URL wasn\'t shortened here!!!"
            redirect_to urls_retrieve_path
        end
    end

    def index
        @urls = Url.all.order(clicks: :desc)
    end
end
