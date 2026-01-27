#!/bin/sh

#加载公共函数
source "`pwd`/until_function.sh"

#指定目录和输出文件
Sort_Folder="`pwd`/temple/sort" 
Download_Folder="`pwd`/temple/download_Rules"
Rules_Folder="`pwd`/Rules"
Base_Rules_Folder="`pwd`/base"

#删除缓存?(也许)
rm -rf "${Rules_Folder}" "`pwd`/temple" 2>/dev/null

#创建目录
mkdir -p "${Download_Folder}" "${Sort_Folder}/rules" "${Rules_Folder}" && echo "※`date +'%F %T'` 创建临时目录成功！"

#设置权限
chmod -R 777 "`pwd`"

#下载规则
download_link "${Download_Folder}"

#处理规则
echo "※`date +'%F %T'` 开始处理规则……"

#复制规则
cp -rf "${Download_Folder}/adblock_auto_lite.txt" "${Sort_Folder}/rules/adblock_auto_lite.txt"
cp -rf "${Base_Rules_Folder}/拦截H转跳.prop" "${Sort_Folder}/rules/拦截H转跳.txt"
cp -rf "${Download_Folder}/jiekouAD.txt" "${Sort_Folder}/rules/jiekouAD.txt"
cp -rf "${Download_Folder}/NoAppDownload.txt" "${Sort_Folder}/rules/NoAppDownload.txt"
cp -rf "${Download_Folder}/cjx-annoyance.txt" "${Sort_Folder}/rules/cjx-annoyance.txt"
cp -rf "${Download_Folder}/Adguard_Cookie.txt" "${Sort_Folder}/rules/Adguard_Cookie.txt"

#去除不必要的"拦截H转跳"
sed -Ei '/\$document/d' "${Sort_Folder}/rules/拦截H转跳.txt"

#合并预处理规则
Combine_adblock_original_file "${Rules_Folder}/AdBlockForVia.txt" "${Sort_Folder}/rules"

#规则小修
fix_Rules "${Rules_Folder}/AdBlockForVia.txt" '\$popup,domain=racaty\.io,0123movie\.ru' '\$popup,domain=racaty\.io\|0123movie\.ru'
fix_Rules "${Rules_Folder}/AdBlockForVia.txt" '##aside:-abp-has' '#\?#aside:-abp-has'
fix_Rules "${Rules_Folder}/AdBlockForVia.txt" '##tr:-abp-has' '#\?#tr:-abp-has'
fix_Rules "${Rules_Folder}/AdBlockForVia.txt" '\$~media,~subdocument,third-party,domain=mixdrp\.co,123movies\.tw\|' '\$~media,~subdocument,third-party,domain=mixdrp\.co\|123movies\.tw\|'
fix_Rules "${Rules_Folder}/AdBlockForVia.txt" '\$third-party,script,_____,domain=' '\$third-party,script,domain='
fix_Rules "${Rules_Folder}/AdBlockForVia.txt" ',_____,domain=' ',domain='

#净化去重规则
modtify_adblock_original_file "${Rules_Folder}/AdBlockForVia.txt"
#移除正则表达式，修复Via卡顿
Remove_regex_Rules_for_via "${Rules_Folder}/AdBlockForVia.txt"
#去除badfilter冲突规则
wipe_badfilter "${Rules_Folder}/AdBlockForVia.txt"
#去除Via不支持的规则
lite_Adblock_Rules "${Rules_Folder}/AdBlockForVia.txt"
#读取白名单 剔除规则
make_white_rules "${Rules_Folder}/AdBlockForVia.txt" "`pwd`/white_list/white_list.prop"
#剔除冲突的CSS规则
fixed_css_white_conflict "${Rules_Folder}/AdBlockForVia.txt"
#去除重复作用域名
Running_sort_domain_Combine "${Rules_Folder}/AdBlockForVia.txt"
#去除指定重复的Css
Running_sort_Css_Combine "${Rules_Folder}/AdBlockForVia.txt"
#修复低级错误
fixed_Rules_error "${Rules_Folder}/AdBlockForVia.txt"
#再次净化去重
modtify_adblock_original_file "${Rules_Folder}/AdBlockForVia.txt"
#精简规则，剔除Via不支持的规则
lite_Adblock_Rules "${Rules_Folder}/AdBlockForVia.txt"
#规则分类
sort_and_optimum_adblock "${Rules_Folder}/AdBlockForVia.txt"
#写入头信息
write_head "${Rules_Folder}/AdBlockForVia.txt" "AdBlockForVia" "适合Via浏览器的广告拦截规则，合并自：混合规则精简版、轻量广告拦截规则、去APP下载提示规则、CJX's Annoyance List、Adguard Cookie" && echo "※`date +'%F %T'` 规则合并完成！"

rm -rf "`pwd`/temple"
#更新README信息
update_README_info
