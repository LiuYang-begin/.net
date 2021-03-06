﻿using CoSales.Common;
using CoSales.DAL;
using CoSales.Model.PO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace CoSales.BLL
{
    public class UserMgr
    {
        public static readonly UserMgr Mgr = new UserMgr();

        public int Add(User entity)
        {
            // 密码保存为密文，密码做加密处理
            entity.Password = EncryptHelper.MD5Encrypt(entity.Password);
            int res = UserDAO.DAO.Add(entity);
            // 主键ID
            entity.ID = res;
            return res;
        }

        public bool Update(User entity)
        {
            entity.Password = EncryptHelper.MD5Encrypt(entity.Password);
            int res = UserDAO.DAO.Update(entity);
            return res > 0;
        }

        /// <summary>
        /// 更新用户基本信息，但不包含密码
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public bool UpdateInfo(User entity)
        {
            int res = UserDAO.DAO.UpdateInfo(entity).GetValueOrDefault(-1);
            return res > 0;
        }

        /// <summary>
        /// 更新用户头像
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public bool UpdateImage(User entity)
        {
            int res = UserDAO.DAO.UpdateImage(entity).GetValueOrDefault(-1);
            return res > 0;
        }

        /// <summary>
        /// 更新密码
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public bool UpdatePwd(string oldPwd, string newPwd, out string msg)
        {
            // 验证原始密码是否正确
            User entity = GetUser(ContextObjects.CurrentUser.UserID, oldPwd);
            if (null == entity)
            {
                msg = "请输入正确的原始密码";
                return false;
            }

            entity.Password = EncryptHelper.MD5Encrypt(newPwd);
            bool res = UserDAO.DAO.UpdatePwd(entity).GetValueOrDefault(-1) > 0;
            msg = res ? "更新成功！" : "密码更新失败！";
            return res;
        }

        public List<User> GetList(object whereConditions = null)
        {
            var res = UserDAO.DAO.GetList(whereConditions);
            return res;
        }

        /// <summary>
        /// 根据userid和password判断用户是否存在
        /// 使用cookie自动进行登录，密码为密文，不需要再次加密，所以需要进行判断
        /// </summary>
        /// <param name="userid"></param>
        /// <param name="pwd"></param>
        /// <param name="isCipherPwd">是否为密文，密码默认为明文</param>
        /// <returns></returns>
        public User GetUser(string userid, string pwd, bool isCipherPwd = false)
        {
            //加密后进行判断。自动登录情况下cookie保存的就是加密后的密文
            string cipher = isCipherPwd ? pwd : EncryptHelper.MD5Encrypt(pwd);
            var res = UserDAO.DAO.GetUser(userid, cipher);
            return res;
        }

        public User GetUser(int id)
        {
            var res = UserDAO.DAO.GetUser(id);
            return res;
        }
    }
}
