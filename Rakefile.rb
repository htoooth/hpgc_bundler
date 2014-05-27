libraries = FileList.new("*.bz2","*.gz")

options ={
    :geos        => '',
    :mpi         => '',
    :proj4       => '',
    :geos        => '',
    :postgresql  => '',
    :postgis     => '',
    :protobuf    => ''
}
def extract_file name
    suffix = File.extname(name)
    base_name = File.basename(name,".tar#{suffix}")
    # case File.extname(name)
    # when '.bz2'
    #     ssh "tar jxvf #{name}"
    # when '.gz'
    #     ssh "tar zxvf #{name}"
    # end
    base_name
end

desc "geos library"
task :geos do
    p extract_file('geos-3.4.2.tar.bz2')
    # geos = extract_file(options[:geos])
    # ssh "cd #{geos}"
    # ssh "./configure --prefix=/opt/#{geos}"
    # ssh "make"
    # ssh "make install"
    # ssh "ln -sf /opt/#{geos} geos"
    # ssh "cd .."
end

desc "proj4 library"
task :proj4 do
    
end

desc "postgresql db"
task :postgresql do
    
end

desc "geo extention on postgresql"
task :postgis => [:postgresql,:proj4,:geos] do
    
end

desc "geo-spatial format library"
task :gdal => [:postgresql,:geos,:proj4,:postgis] do
    
end

desc "message passing interface library"
task :mpi do
    
end

desc "google protobuf library"
task :protobuf do
    
end

task :default => [:gdal,:mpi,:postgis,:protobuf]