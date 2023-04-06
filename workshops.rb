require 'sinatra'

def workshop_content(name)
    File.read("workshops/#{name}.txt")
rescue Errno::ENOENT
    return nil
end

def save_workshop(name, description)
    File.open("workshops/#{name}.txt", 'w') do |file|
        file.write(description)
    end
end

def delete_workshop(name)
    File.delete("workshops/#{name}.txt")
end

get '/' do
    @files = Dir.entries('workshops')
    erb :home
end

get '/create' do
    erb :create
end

get '/:name' do
    @name = params[:name]
    @description = workshop_content(@name)
    erb :workshop
end

get '/:name/edit' do
    @name = params[:name]
    @description = workshop_content(@name)
    erb :edit
end

post '/create' do
    @name = params[:name]
    save_workshop(@name, params[:description])
    @message = "El taller #{@name} fue creado exitosamente"
    erb :message
end

delete '/:name' do
    @name = params[:name]
    delete_workshop(@name)
    @message = "El taller #{@name} fue eliminado exitosamente"
    erb :message
end

put '/:name' do
    save_workshop(params[:name], params[:description])
    redirect "/#{params[:name]}"
end