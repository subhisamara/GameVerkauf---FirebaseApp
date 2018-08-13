README:

Zur anfang diese steps folgen:

1. Git Bash runterladen, Alternativen geht auch gut.
2. Git global setup:
    - cd bis zum Ordner wo du dein local repo. haben möchtest
    - CMD Befehle:
        - ein Ordner zurück: cd ..
        - ein Ordner weiter: cd OrderName
        - zeige inhalt von current Ordner:
            in git bash: ls
            in cmd: dir
    1. git config --global user.name "UserName"
    2. git config --global user.email "email@cip.ifi.lmu.de"
3. git clone https://gitlab.cip.ifi.lmu.de/samara/ios-ss17.git
4. Falls nötig: cd existing_folder
5. git checkout master
6. git pull
7. dein Branch offnen:	git checkout <branchname>
    - Jeder von uns hat sein eigen Branch:
    -  z.B Subhi hat Branch: subhi
    -  git checkout subhi
8. Hast du alles gemacht? jetzt kannst du kodieren
9. hast du ein teil fertig in deinem Branch und willst pushen?
    - Git Bash offnen, dann cd zur local Rep.
    - git add -A
    - git git commit -m "Commit message"
    - git push origin <deinBranch>
10. weiter kodieren auf dein Branch bis dein Aufgabe fertig
11. pushen wie in step 9.
12. Merge-Person kontaktieren
13. sobald eine Mergebestätigung von Merge-Person kommt, mach das folgende:
    - Git Bash offnen, dann cd zur local Rep. Master (Du solltest Master noch da haben)
    - git pull
    - git checkout -b <deinName>
    - weiter von step 8.
++++Sehr wichtig+++ 
1. Immer local arbeiten.
2. Immer auf eigen Branch arbeiten der vom Master entsteht.
3. Befehle richtig schreiben.
4. beim commit, kommentar gut schreiben damit anderen auch verstehen können was du gemacht hast.
5. falls irgendwas schief läuft, nicht pushen und anderen kontaktieren.
6. nur eine Person machen mergen.

+++++ weiter git befehele:
    - https://confluence.atlassian.com/bitbucketserver/basic-git-commands-776639767.html