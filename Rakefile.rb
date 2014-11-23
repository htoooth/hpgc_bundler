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
    
    action = {}
    action['.tar.bz2'] = 'tar -jxvf'
    action['.tar.gz'] = 'tar -zxvf'
    action['.bz2'] = 'bzip2 -d'
    action['.7z'] = 'p7zip -d'
    action['.zip'] = 'unzip'
    
    extension = name.scan(/\.[a-z]+\S+/).join
    base_name = File.basename(name,extension)
    sh "#{action[extension]} #{name}"
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

task :gflags,[:output] do |t,args|
    orgin_dir = getwd()
    # compile and install
    base = extract_file(options[:gflags])
    cd "#{base}"
    sh "cmake ."
    sh "make"
    
    makedirs "#{args[:output]}/#{base}"
    
    cp_r "include","#{args[:output]}/#{base}"
    cp_r "lib","#{args[:output]}/#{base}"
    
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

task :gtest,[:output] do |t,args|
    orgin_dir = getwd()
    # compile and install
    base = extract_file(options[:gtest])
    cd "#{base}"
    sh "cmake ."
    sh "make"
    
    makedirs "#{args[:output]}/#{base}"
    makedirs "#{args[:output]}/#{base}/lib"
    
    cp_r "include","#{args[:output]}/#{base}"
    cp_r %w(libgtest.a libgtest_main.a),"#{args[:output]}/#{base}/lib"
    
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

task :gmock,[:output] do |t,args|
    orgin_dir = getwd()
    # compile and install
    base = extract_file(options[:gmock])
    cd "#{base}/make"
    sh "make"
    
    makedirs "#{args[:output]}/#{base}/include"
    makedirs "#{args[:output]}/#{base}/lib"

    cp_r "gmock_main.a","#{args[:output]}/#{base}/lib/libgmock.a"
    
    cd ".."
    cp_r "include/gmock","#{args[:output]}/#{base}/include"
    
    cd "gtest"
    cp_r "include/gtest","#{args[:output]}/#{base}/include"
    
    cd ".."
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
    #sh "rake simple[gprotobuf,#{args[:output]}]"
    #sh "rake gflags[#{args[:output]}]"
    sh "rake gmock[#{args[:output]}]"
    
    #sh "rake gtest[#{args[:output]}]"
    #sh "rake simple[glog,#{args[:output]}]"
end
