��            )   �      �     �     �  (   �  *   �  R   �  X   P  9   �  ?   �     #     /     M  ;   e  >   �  D   �     %     B     `  i     6   �        $   <  ,   a  #   �     �  0   �             ,   =  )   j  -  �     �     �  )   �  *   �  _   	  f   	  I   �	  P   0
     �
     �
     �
  A   �
  H     O   N  &   �  '   �     �  |     :   �     �  %   �  3     %   7  )   ]  .   �  &   �  #   �  6     3   8                                            
                                                                                     	        	%+#D 
 ${errnum}/${total} backup action failed. ${succnum}/${total} backup action succeed. Dump Backup Database [${database}] (ignore: ${ignore_table}) return [${errstuff1}] Dump Backup Database [${database}] (ignore: ${ignore_table}) succeed. size=[${dt_size}]K Dump Backup Table [${table}] Schema return [${errstuff2}] Dump Backup Table [${table}] Schema succeed. size=[${dt_size}]K ERROR_INFO: Esop Database BackUp CRITICAL Esop Database BackUp OK InnoBackupex Backup Skip, as [${backupex_tbfile}] is empty. InnoBackupex Backup [${backupex_tbfile}] return [${errstuff3}] InnoBackupex Backup [${backupex_tbfile}] succeed. size=[${dt_size}]M backup_savedir: not defined. backupex_tbfile: not defined. create backup directory failed database backup from mysql [${mysql_host}:${mysql_port}] with user [${mysql_user}] by [${mysqldump_path}] directory: [${backup_savedir}] not exist or accessable dump backup save directory: file [${backupex_tbfile}] not exist. file [${mysqlconf_path}] not exist or empty. innobackupex backup save directory: innobackupex_path: not defined. mysql_conn_conf: [${mysql_conn_conf}] is invalid mysqlconf_path: not defined. mysqldump_path: not defined. utitile [${innobackupex_path}] not prepared. utitile [${mysqldump_path}] not prepared. Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: MOLE-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
 ${errnum}/${total} 个备份动作失败. ${succnum}/${total} 个备份动作成功. Dump备份数据库 ${database}(不包含表${ignore_table}) 失败, 失败信息: ${errstuff1} Dump备份数据库 ${database}(不包含表${ignore_table}) 成功. 备份文件大小为 ${dt_size}K Dump备份数据表 ${table} 表结构 失败, 失败信息: ${errstuff2} Dump备份数据表 ${table} 表结构 成功. 备份文件大小为 ${dt_size}K 失败信息: ESOP数据库备份失败 ESOP数据库备份成功 InnoBackupex备份跳过, 因为 ${backupex_tbfile} 为空文件. InnoBackupex备份 ${backupex_tbfile} 失败, 失败信息: ${errstuff3} InnoBackupex备份 ${backupex_tbfile} 成功. 备份文件大小为 ${dt_size}M 配置参数 backup_savedir 未定义. 配置参数 backupex_tbfile 未定义. 创建备份目录失败. 使用 ${mysqldump_path} 以Mysql用户 ${mysql_user} 的权限从如下地址: ${mysql_host}:${mysql_port} 备份数据库. 目录 [${backup_savedir}] 不存在或没有写入权限. Dump备份的导出目录为: [${backupex_tbfile}] 文件不存在. [${mysqlconf_path}] 文件不存在或为空文件. InnoBackupex备份的导出目录为: 配置参数 innobackupex_path 未定义. Mysql连接配置不识别: ${mysql_conn_conf} 配置参数 mysqlconf_path 未定义. 配置参数 not defined 未定义. [${innobackupex_path}] 不存在或没有执行权限. [${mysqldump_path}] 不存在或没有执行权限. 