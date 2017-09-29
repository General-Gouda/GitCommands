function New-GitInit
{
	git init
	git add .
	git commit -m 'Initial Commit'
	git status
}