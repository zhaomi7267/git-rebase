# 放弃本地修改
drop:
	git add .; git stash; git stash drop


# 拉取远程代码
pull:
	git pull --rebase


# 合并当前分支到测试分支
test%:
	@# echo $*;
	- git branch -D dev$*;
	git fetch;
	export branch=`git branch | grep \* | grep -Eo ' .+'` && \
		echo "当前分支: $$branch" && \
		git checkout test$* && \
		git pull --rebase && \
		echo "merging: \033[0;31morigin/master\033[0m" && \
		git merge origin/master && \
		echo "merging: \033[0;31m$$branch\033[0m" && \
		git merge $$branch && \
		git push && \
		git checkout $$branch;
	@ echo "\n自动发布中";

# 合并当前分支到开发分支
dev%:
	@# echo $*;
	- git branch -D dev$*;
	git fetch;
	export branch=`git branch | grep \* | grep -Eo ' .+'` && \
		echo "当前分支: $$branch" && \
		git checkout dev$* && \
		git pull --rebase && \
		echo "merging: \033[0;31morigin/master\033[0m" && \
		git merge origin/master && \
		echo "merging: \033[0;31m$$branch\033[0m" && \
		git merge $$branch && \
		git push && \
		git checkout $$branch;
	@ echo "\n自动发布中";

# 快速rebase master
rebase:
	export branch=`git branch | grep \* | grep -Eo ' .+'` && \
		git checkout master && \
		git pull --rebase && \
		git checkout $$branch && \
		git rebase master;

# 合并master，使用对方的修改解决冲突
mt:
	export branch=`git branch | grep \* | grep -Eo ' .+'` && \
		git checkout master && \
		git pull --rebase && \
		git checkout $$branch && \
		git merge --abort;git merge master --strategy-option theirs;

# 合并master，使用自己的修改解决冲突
mo:
	export branch=`git branch | grep \* | grep -Eo ' .+'` && \
		git checkout master && \
		git pull --rebase && \
		git checkout $$branch && \
		git merge --abort;git merge master --strategy-option ours;

# 合并 commit
reset:
	@echo "------以下为你的commit信息-------"
	@git log master.. --pretty=format:%B | grep -vE '^\s*$$' | cat
	@echo "\n\n------代码已经reset成功，请add commit有意义的提交信息-------"
	@git log master.. --pretty=format:"%P" --reverse | head -1 | xargs git reset --soft; git reset HEAD . > /tmp/webApp.gitreset.log; git status