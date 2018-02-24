create table cubes (id int, model_file varchar(255), state varchar(255), primary key (id));
insert into cubes values (0, 'dog.model', 'running');
insert into cubes values (1, 'corpse.model', 'rotting');
insert into cubes values (2, 'corpse.model', 'fresh');
insert into cubes values (3, 'rat.model', 'eating cheese');
insert into cubes values (4, 'cat.model', 'sleeping');
insert into cubes values (5, 'painting.model', 'ready');

create table use_cases (id int, name varchar(255), script_file varchar(255), primary key (id));
insert into use_cases values (0, 'kossu', 'kossu.script');
insert into use_cases values (1, 'doom', 'doom.script');
insert into use_cases values (2, 'toys', 'toys.script');

create table case_cubes (caseid int, cubeid int,
   primary key (caseid, cubeid),
   foreign key (cubeid) references cubes,
   foreign key (caseid) references use_cases );
insert into case_cubes values (0, 0);
insert into case_cubes values (0, 1);
insert into case_cubes values (1, 2);
insert into case_cubes values (1, 3);
insert into case_cubes values (2, 3);
insert into case_cubes values (2, 4);

