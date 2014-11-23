libraries = FileList.new("*.bz2","*.gz")

options ={
    :geos        => 'geos-3.4.2.tar.bz2',
    :proj4       => 'proj-4.8.0.tar.gz',
    :geos        => 'geos-3.4.2.tar.bz2',
    
    :postgresql  => 'postgresql-9.3.4.tar.bz2',
    :postgis     => 'postgis-2.1.3.tar.gz',
    
    :mpi         => 'openmpi-1.6.5.tar.bz2',
    
    :gprotobuf   => 'protobuf-2.5.0.tar.bz2',
    :gflags      => 'gflags-2.1.1.tar.gz',
    :gmock       => 'gmock-1.7.0.zip',
    :gperf       => 'gperftools-2.2.tar.gz',
    :gtest       => 'gtest-1.7.0.zip',
    :glog        => 'glog-0.3.3.tar.gz'
    
}
def extract_file name
    suffix = File.extname(name)
    base_name = File.basename(name,".tar#{suffix}")
    #case File.extname(name)
    #when '.bz2'
    #     sh "tar jxvf #{name}"
    #when '.gz'
    #     sh "tar zxvf #{name}"
    #when '.zip'
    #     sh "unzip #{name}"
    #end
    #base_name
    p base_name
    p suffix
end

desc "geos library"
task :geos do
    p extract_file('gv-3.4.2.tar.bz2')
    # geos = extract_file(options[:geos])
    # sh "cd #{geos}"
    # sh "./configure --prefix=/opt/#{geos}"
    # sh "make"
    # sh "make install"
    # sh "ln -sf /opt/#{geos} geos"
    # sh "cd .."
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