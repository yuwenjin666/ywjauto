#!/bin/bash
#********************************************************************
# This bash is to test for Linux to use
# The author is Wenjin Yu and is personally owned and commercial use is strictly prohibited.
#
#Author:           yuwenjin
#QQ:               2784877094
#Date:             2024-04-24
#FileName:         wenjinauto.sh
#URL: https://gitee.com/yuwenjin0123/wjnuli.git
#Description： operate system auto deplot
#Copyright (C):     2024 All rights reserved
#********************************************************************

fontColor_Yellow=$(echo -e '\E[1;33m')
fontColor_Red=$(echo -e '\E[1;31m')
fontColor_Green=$(echo -e '\E[1;32m')
fontColor_Blue=$(echo -e '\E[1;33m')
fontColor_Purple=$(echo -e '\E[1;34m')
colorEnd=$(echo -e "\E[0m" )

####安装epel-release
install_epel() {
  
  if ping -c 3 www.baidu.com &> /dev/null ;then  
    yum install -y epel-release
    echo "$fontColor_Blue" install finish ^.^ "$colorEnd"
  else
    echo "$fontColor_Red" network cannot connect to Internet "$colorEnd"
  fi
}

###关闭selinux
stop_selinux(){
  sed -rni "s/^(SELINUX=).*/\1disabled/" /etc/selinux/config &> /dev/null
  setenforce &> /dev/null 0 ; echo "更改成功,重启永久生效"
}
##关闭防火墙
stop_firewalld(){
  systemctl disable firewalld --now  &> /dev/null
  echo "$fontColor_Red" 已关闭防火墙 "$colorEnd"
}
##初始化网卡名称
intal_eth0(){
  sed -ri.bak 's/^(GRUB_CMDLINE_LINUX.*)"/\1 net.ifnames=0"/' /etc/default/grub
  grub2-mkconfig -o /etc/grub2.cfg  ; echo "重启永久生效"
}
##查看系统信息
system_info(){
  . /etc/os-release
  echo -e  "HOSTNAME:     $fontColor_Red `hostname` $colorEnd"
  echo -e  "IPADDR:       $fontColor_Red ` hostname -I` $colorEnd"
  echo -e  "OSVERSION:    $fontColor_Red $PRETTY_NAME $colorEnd"
  echo -e  "KERNEL:       $fontColor_Red `uname -r` $colorEnd"
  echo -e  "CPU:         $fontColor_Red `cat /proc/cpuinfo|grep '^[Mm]odel name'|tr -s ' '|cut -d : -f2 | uniq` $colorEnd"
  echo -e  "MEMORY:       $fontColor_Red `free -h|grep Mem|tr -s ' ' : |cut -d : -f2` $colorEnd"
  echo -e  "DISK:         $fontColor_Red `lsblk |grep '^sd' |tr -s ' ' |cut -d " " -f4` $colorEnd"
}
###安装软件
install_app() {
  while : ;do
    printf "\n"
    echo  "$fontColor_Red" ----------------------安装操作-------------------- "$colorEnd"
    echo "$fontColor_Yellow" 1.安装epel-release源 "$colorEnd"
    echo "$fontColor_Yellow" 2.按0退出 "$colorEnd"
    echo  "$fontColor_Red" ----------------------END-------------------------- "$colorEnd"
    read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m' )" option2
    case $option2 in
    1)
      #安装epel源
      install_epel
      ;;
    0)
      echo "$fontColor_Blue" quit "$colorEnd"
      exit 0
      ;;
    *)
      echo -e "\033[1;36m输入错误！\033[0m"
    esac
  done
}
inital_configuration() {
  while : ; do
    printf "\n"
    echo  "$fontColor_Red" ----------------------基础环境配置------------------ "$colorEnd"
    echo  "$fontColor_Green" 1.关闭selinux "$colorEnd"
    echo  "$fontColor_Green" 2.关闭防火墙 "$colorEnd"
    echo  "$fontColor_Green" 3.初始化网卡名称 "$colorEnd"
    echo  "$fontColor_Green" 4.查看系统信息 "$colorEnd"
    echo  "$fontColor_Green" 5.查看磁盘信息 "$colorEnd"
    echo  "$fontColor_Green" 退出 "$colorEnd"
    echo  "$fontColor_Red" ----------------------END-------------------------- "$colorEnd"
    read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m')" option2 
    case $option2 in
    1)
      stop_selinux
      ;;
    2)
      stop_firewalld
      ;;
    3)
      intal_eth0
      ;;
    4)
      system_info
      ;;
    0)
      exit 0
      ;;
    *)

    esac
  done
}
##基础配置目录
basic_config() {
  while : ;do
    printf "\n"
    echo  "$fontColor_Red" ----------------------基础配置-------------------- "$colorEnd"
    echo "$fontColor_Purple" 1.进入安装操作 "$colorEnd"
    echo "$fontColor_Purple" 2.基础环境配置 "$colorEnd"
    echo "$fontColor_Purple"   按0退出 "$colorEnd"
    echo  "$fontColor_Red" ----------------------END-------------------------- "$colorEnd"
    printf "\n"
    read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m' )" option1
    case $option1 in
    1)
      install_app
      ;;
    2)
      inital_configuration
      ;;
    0)
      exit 2
      ;;
    *)
      echo -e "\033[1;36m输入错误！\033[0m"
    esac
  done
}

#一层目录
while : ;do
  printf "\n"
  echo  "$fontColor_Red" ----------------------自动化配置-------------------- "$colorEnd"
  echo  "$fontColor_Yellow" 1.进入基础配置 "$colorEnd"
  echo  "$fontColor_Yellow"   按0退出 "$colorEnd"
  echo  "$fontColor_Red" ----------------------END-------------------------- "$colorEnd"
  read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m')" option
  case $option in
  1)
     #初始化配置
     basic_config
     ;;
  0)
     #退出
     break
     ;;
  *)
    echo -e "\033[1;36m输入错误！\033[0m"
  esac
done



