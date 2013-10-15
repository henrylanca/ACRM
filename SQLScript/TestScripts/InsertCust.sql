select * into #temp from gbal
where cno = '2000002'

update #temp set CNO='2000212'

insert into gbal
select * from #temp

drop table #temp

go

