options ={
    :geos        => 'geos-3.4.2.tar.bz2',
    :proj4       => 'proj-4.8.0.tar.gz',
    :gdal        => 'gdal-1.11.0.tar.gz',
    
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
    case File.extname(name)
    when '.bz2'
        sh "tar jxvf #{name}" 
    when '.gz'
        sh "tar zxvf #{name}" 
    when '.zip'
        sh "unzip #{name}" 
    end
    base_name
end

desc "run simple task "
task :simple ,[:target,:output] do |t,args|
    orgin_dir = getwd()
    
    # compile and install
    base = extract_file(options[args[:target].to_sym])
    cd "#{base}"
    sh "./configure --prefix=#{args[:output]}/#{base}"
    sh "make"
    sh "make install"
    
    # clean 
    cd ".."
    rm_rf "#{base}"
    
    # make link
    sym_name = base.split("-")[0]
    cd "#{args[:output]}"
    ln_sf "#{args[:output]}/#{base}",sym_name
    
    # return 
    cd orgin_dir
end

desc "install all packages [$HOME/hpgc]"
task :install,[:output] do |t,args|
    sh "rake simple[gprotobuf,#{args[:output]}]"
    sh "rake simple[gflags,#{args[:output]}]"
    sh "rake simple[gmock,#{args[:output]}]"
    sh "rake simple[gperf,#{args[:output]}]"
    sh "rake simple[gtest,#{args[:output]}]"
    sh "rake simple[glog,#{args[:output]}]"
end
