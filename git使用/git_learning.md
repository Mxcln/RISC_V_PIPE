## GitHub 学习笔记

[toc]
Q 按键:在查看 git log 时作为 return

### 时光机穿梭

#### 版本退回

HEAD 指向的版本就是当前版本，因此，Git 允许我们在版本的历史之间穿梭，使用命令 git reset --hard commit_id。
穿梭前，用 git log 可以查看提交历史，以便确定要回退到哪个版本。
要重返未来，用 git reflog 查看命令历史，以便确定要回到未来的哪个版本,也可以 git log 查看提交历史。然后输入 git reset --hard commit_id

#### 管理/撤销修改

git add .
git commit -m "备注"
git diff head -- <filename> 查看工作区和版本库里面最新版本的区别

### 分支管理

#### 创建与合并分支

指针的概念
查看分支：git branch
创建分支：git branch <name>
切换分支：git checkout <name>或者 git switch <name>
创建+切换分支：git checkout -b <name>或者 git switch -c <name>
合并某分支到当前分支：git merge <name>
删除分支：git branch -d <name>

#### 解决冲突

当 Git 无法自动合并分支时，就必须首先解决冲突。解决冲突后，再提交，合并完成。
解决冲突就是把 Git 合并失败的文件手动编辑为我们希望的内容，再提交。
用 git log --graph 命令可以看到分支合并图。

#### 多人协作

首先，可以试图用 git push origin <branch-name>推送自己的修改；

如果推送失败，则因为远程分支比你的本地更新，需要先用 git pull 试图合并；

如果合并有冲突，则解决冲突，并在本地提交；

没有冲突或者解决掉冲突后，再用 git push origin <branch-name>推送就能成功！

如果 git pull 提示 no tracking information，则说明本地分支和远程分支的链接关系没有创建，用命令 git branch --set-upstream-to <branch-name> origin/<branch-name>。

这就是多人协作的工作模式，一旦熟悉了，就非常简单。
