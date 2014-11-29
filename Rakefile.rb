options ={
    :geos        => 'geos-3.3.9.tar.bz2',
    :proj        => 'proj-4.8.0.tar.gz',
    :gdal        => 'gdal-1.11.0.tar.gz',
    
    :postgresql  => 'postgresql-9.3.4.tar.bz2',
    :postgis     => 'postgis-2.1.4.tar.gz',
    
    :mpi         => 'openmpi-1.8.3.tar.gz',
    
    :gprotobuf   => 'protobuf-2.5.0.tar.bz2',
    :gflags      => 'gflags-2.1.1.tar.gz',
    :gmock       => 'gmock-1.7.0.zip',
    :gtest       => 'gtest-1.7.0.zip',
    :glog        => 'glog-0.3.3.tar.gz',
    
    :boost       => 'boost_1_57_0.tar.bz2'
    
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

desc "run simple install task suck as glog,geos,proj,mpi"
task :simple ,[:target,:output] do |t,args|
    orgin_dir = getwd()
    
    # compile and install
    base = extract_file(options[args[:target].to_sym])
    cd "#{base}"
    sh "./configure --prefix=#{args[:output]}/#{base}"
    sh "make -j4"
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

desc "install gflags"
task :gflags,[:output] do |t,args|
    orgin_dir = getwd()
    # compile and install
    base = extract_file(options[:gflags])
    cd "#{base}"
    sh "cmake ."
    sh "make -j4"
    
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

desc "install gtest"
task :gtest,[:output] do |t,args|
    orgin_dir = getwd()
    # compile and install
    base = extract_file(options[:gtest])
    cd "#{base}"
    sh "cmake ."
    sh "make -j4"
    
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

desc "install gmock"
task :gmock,[:output] do |t,args|
    orgin_dir = getwd()
    # compile and install
    base = extract_file(options[:gmock])
    cd "#{base}/make"
    sh "make -j4"
    
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

desc "install gdal"
task :gdal ,[:output] do |t,args|
     orgin_dir = getwd()
    
    # compile and install
    base = extract_file(options[:gdal])
    cd "#{base}"
    sh %Q{./configure --prefix=#{args[:output]}/#{base} \
--with-geos=#{args[:output]}/geos/bin/geos-config \
--with-pg=#{args[:output]}/postgresql/bin/pg_config \
--with-static-proj4=#{args[:output]}/proj \
--with-python
}
        
    sh "make -j4"
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

desc "install postgresql"
task :postgresql ,[:output] do |t,args|
    orgin_dir = getwd()
    
    # compile and install
    base = extract_file(options[:postgresql])
    cd "#{base}"
    sh "./configure --prefix=#{args[:output]}/#{base} --without-readline --without-zlib"
    sh "make -j4"
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

desc "install postgis"
task :postgis ,[:output] do |t,args|
     orgin_dir = getwd()
    
    # compile and install
    base = extract_file(options[:postgis])
    cd "#{base}"
    sh %Q{./configure --prefix=#{args[:output]}/#{base} \
--with-geosconfig=#{args[:output]}/geos/bin/geos-config \
--with-pgconfig=#{args[:output]}/postgresql/bin/pg_config \
--with-projdir=#{args[:output]}/proj \
--with-gdalconfig=#{args[:output]}/gdal/bin/gdal-config \
--with-raster --with-topology 
}
    sh "make -j4"
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

desc "install boost"
task :boost,[:output] do |t,args|
    orgin_dir = getwd()
    
    # compile and install
    base = extract_file(options[:boost])
    cd "#{base}"
    
    sh "./bootstrap.sh --prefix=#{args.output}"
    sh "./b2 install"
    
    # clean 
    cd ".."
    rm_rf "#{base}"
    
    # make link
    sym_name = base.split("_",2)[0]
    cd "#{args[:output]}"
    ln_sf "#{args[:output]}/#{base}",sym_name
    
    # return 
    cd orgin_dir
    
end

desc "install all packages [$HOME/hpgc]"
task :install,[:output] do |t,args|
    Rake::Task['simple'].invoke('mpi',args.output)
    Rake::Task['simple'].reenable
    
    Rake::Task['simple'].invoke('gprotobuf',args.output)
    Rake::Task['simple'].reenable
    
    Rake::Task['gflags'].invoke(args.output)
    Rake::Task['gmock'].invoke(args.output)
    
    Rake::Task['simple'].invoke('glog',args.output)
    Rake::Task['simple'].reenable
    
    Rake::Task['simple'].invoke('geos',args.output)
    Rake::Task['simple'].reenable
    
    Rake::Task['simple'].invoke('proj',args.output)
    Rake::Task['simple'].reenable
    
    Rake::Task['postgresql'].invoke(args.output)
    Rake::Task['gdal'].invoke(args.output)
    
    Rake::Task['postgis'].invoke(args.output)
    
    Rake::Task['boost'].invoke(args.output)
end

desc "update project"
task :update do
    sh 'git pull' 
end

desc "commit project" 
task :commit do
    sh "git add -A"
    sh "git commit -m \"update file\" "
    sh "git push -u origin master"
end

