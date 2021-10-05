# lfs-testing

- change device in lfs.sh

```bash
chmod +x lfs.sh
```
- Then run with ./lfs.sh 

### Found bugs

- File 5.38 can not be used to comple File 5.4. May either replace to 5.38 in packages.csv or try on fedora, and rewrite the apt parts of script to dnf/yum, we'll see. 
