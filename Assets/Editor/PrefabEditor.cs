using System.IO;
using System.Xml;
using System.Reflection;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine.UI;
using System;
using UnityEditor.Animations;

public class PrefabEditor
{
    public enum EmPrefabType
    {
        emPrefabType_MonsterBattle = 0,        //NPC战斗状态
        emPrefabType_RoleBattle = 1,        //玩家战斗状态
        emPrefabType_MonsterNormal = 2,        //怪物正常状态
        emPrefabType_RoleNormal = 3,        //玩家正常状态
    }
    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/CreateNpcPrefabs")]
    private static void CreateMonsterPrefabs()
    {
        string imgFolder = "Textures/npc/";
        string prefabFolder = "Prefabs/Entity/NPC/";
        string aniFolder = "Assets/Animation/NPC/";

        if (!EditorUtility.DisplayDialog("功能确认", "确定要创建NPC战斗状态下的预设吗？", "确定"))
        {
            return;
        }

        //批量创建预设
        string genPath = Application.dataPath + "/" + imgFolder;
        string[] foderPath = Directory.GetDirectories(genPath);
        List<string> listBattleName = new List<string>();
        List<string> listNormalName = new List<string>();
        string prefabNameBattle = "";
        string prefabNameNormal = "";
        for (int i = 0; i < foderPath.Length; i++)
        {
            string url = foderPath[i];
            int index = url.LastIndexOf("/");
            string npcID = url.Substring(index + 1, url.Length - index - 1);
            string pUrl = Application.dataPath + "/" + prefabFolder + npcID + ".prefab";

            if (npcID.IndexOf("_battle") > 0)
            {
                if (File.Exists(pUrl))
                {
                    //已经创建过预设的
                    prefabNameBattle = "Assets/" + prefabFolder + npcID + ".prefab";
                    continue;
                }
                listBattleName.Add(npcID);
            }
            else
            {
                if (File.Exists(pUrl))
                {
                    //已经创建过预设的
                    prefabNameNormal = "Assets/" + prefabFolder + npcID + ".prefab";
                    continue;
                }
                listNormalName.Add(npcID);
            }
        }
        if (string.IsNullOrEmpty(prefabNameNormal))
        {
            EditorUtility.DisplayDialog("NPC普通状态", "需要至少存在一个已经创建的NPC预设", "确定");
        }
        if (string.IsNullOrEmpty(prefabNameBattle))
        {
            EditorUtility.DisplayDialog("NPC战斗状态", "需要至少存在一个已经创建的NPC预设", "确定");
        }
        if (string.IsNullOrEmpty(prefabNameNormal) && string.IsNullOrEmpty(prefabNameBattle))
        {
            return;
        }
        if (listBattleName.Count + listNormalName.Count == 0)
        {
            EditorUtility.DisplayDialog("成功", "没有可创建的怪物预设", "确定");
            return;
        }
        List<UnityEngine.Object> objList = new List<UnityEngine.Object>();
        //正常状态
        if (!string.IsNullOrEmpty(prefabNameNormal))
        {
            //复制的预设
            GameObject _prefab = AssetDatabase.LoadAssetAtPath(prefabNameNormal, typeof(GameObject)) as GameObject;
            //创建预设
            for (int i = 0; i < listNormalName.Count; i++)
            {
                string fileName = listNormalName[i];
                string npcName = fileName;

                //解析动画xml数据
                AnimationData animationData = ParseAnimationData("Assets/config/" + fileName + ".xml");
                if (animationData.dicActionData.Keys.Count == 0)
                {
                    continue;
                }
                CreateNormalPrefab(_prefab, imgFolder, genPath, prefabFolder, aniFolder, npcName, npcName, EmPrefabType.emPrefabType_MonsterNormal);

                //刷新进度条
                //MonoBehaviour.DestroyImmediate(tempPrefab, true);
                UpdateProgress(i, listNormalName.Count + listNormalName.Count, "创建怪物预设:" + fileName);
                //objList.Add(tempPrefab);
                AssetDatabase.SaveAssets();
            }
        }
        if (prefabNameBattle != null)
        {
            //复制的预设
            GameObject _prefab = AssetDatabase.LoadAssetAtPath(prefabNameBattle, typeof(GameObject)) as GameObject;
            //创建预设
            for (int i = 0; i < listBattleName.Count; i++)
            {
                string fileName = listBattleName[i];
                //string npcName = fileName.Substring(0, fileName.IndexOf("_battle"));

                //解析动画xml数据
                AnimationData animationData = ParseAnimationData("Assets/config/" + fileName + ".xml");
                if (animationData.dicActionData.Keys.Count == 0)
                {
                    continue;
                }
                ActionData standData = animationData.dicActionData["stand"];

                string url = "Assets/" + prefabFolder + fileName + ".prefab";
                //GameObject prefabObj = AssetDatabase.LoadAssetAtPath(url, typeof(GameObject)) as GameObject;
                UnityEngine.Object tempPrefab = PrefabUtility.CreateEmptyPrefab(url);
                tempPrefab = PrefabUtility.InstantiatePrefab(_prefab);
                tempPrefab.name = fileName;

                //更新Sprite的锚点
                UpdateDirectorySpritePivot(animationData, genPath + fileName + "/");

                ActionData actData = standData;
                actData.nFrameNum = actData.keyFrame = 0;
                animationData.dicActionData.Add("run", actData);

                actData = standData;
                actData.nFrameNum = actData.keyFrame = 0;
                animationData.dicActionData.Add("back", actData);

                //设置头顶和胸部位置
                CBattleRole battleRole = ((GameObject)tempPrefab).GetComponent<CBattleRole>();
                if (battleRole == null)
                {
                    battleRole = ((GameObject)tempPrefab).AddComponent<CBattleRole>();
                }
                //设置预设里默认头顶和胸部位置，以stand动作里的位置为默认值
                GameObject chestObj = ((GameObject)tempPrefab).transform.FindChild("chestPos").gameObject;
                if (chestObj == null)
                {
                    chestObj = new GameObject("chestPos");
                    chestObj.transform.SetParent(((GameObject)tempPrefab).transform, false);
                }
                chestObj.transform.localPosition = new Vector3(standData.fChestX, standData.fChestY, 0);

                //canvas
                GameObject canvasObj = ((GameObject)tempPrefab).transform.FindChild("Canvas").gameObject;
                if (canvasObj != null)
                {
                    Canvas canvas = canvasObj.GetComponent<Canvas>();
                    if (canvas != null)
                    {
                        RectTransform rtf = canvas.GetComponent<RectTransform>();
                        rtf.localPosition = new Vector3(standData.fHeadX, standData.fHeadY, 0);
                    }
                }

                GameObject bodySprite = ((GameObject)tempPrefab);//.transform.FindChild("bodySprite").gameObject;
                if (bodySprite != null)
                {
                    //创建动画
                    UnityEditor.Animations.AnimatorController animatorController = DoCreateAnimationAssets("/" + imgFolder + fileName, animationData, aniFolder, EmPrefabType.emPrefabType_MonsterBattle);

                    SpriteRenderer spr = bodySprite.GetComponent<SpriteRenderer>();
                    if (spr == null)
                    {
                        spr = bodySprite.AddComponent<SpriteRenderer>();
                    }
                    spr.sprite = AssetDatabase.LoadAssetAtPath<Sprite>("Assets/" + imgFolder + fileName + "/stand_01.png");

                    Animator animator = bodySprite.GetComponent<Animator>();
                    if (animator == null)
                    {
                        animator = bodySprite.AddComponent<Animator>();
                    }
                    animator.runtimeAnimatorController = animatorController;
                }

                battleRole.m_nAttackDistance = animationData.m_nAttackDistance; //攻击距离
                battleRole.m_arrCanvasPos = new Vector2[(int)EmActionType.emActionMaxNum];
                battleRole.m_arrChestPos = new Vector2[(int)EmActionType.emActionMaxNum];
                foreach (string key in animationData.dicActionData.Keys)
                {
                    ActionData actionData = animationData.dicActionData[key];
                    int nIndex = GetIndexByActionName(key);
                    if (nIndex >= 0)
                    {
                        battleRole.m_arrCanvasPos[nIndex] = new Vector2(actionData.fHeadX, actionData.fHeadY);
                        battleRole.m_arrChestPos[nIndex] = new Vector2(actionData.fChestX, actionData.fChestY);
                    }
                }

                //创建预设，保存预设，刷新进度条
                UnityEngine.Object prefab = PrefabUtility.CreateEmptyPrefab(url);
                tempPrefab = PrefabUtility.ReplacePrefab((GameObject)tempPrefab, prefab);
                //MonoBehaviour.DestroyImmediate(tempPrefab, true);
                UpdateProgress(i, listBattleName.Count + listNormalName.Count, "创建怪物预设:" + fileName);
                objList.Add(tempPrefab);
                AssetDatabase.SaveAssets();
            }
        }

        foreach (UnityEngine.Object obj in objList)
        {
            //GameObject.DestroyImmediate(obj, true);
        }
        objList = new List<UnityEngine.Object>();

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设创建完成！", "确定");
    }

    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/CreateFunNpcPrefabs")]
    private static void CreateFunNpcPrefabs()
    {
        string imgFolder = "Textures/npc/";
        string prefabFolder = "Prefabs/Entity/NPC/";
        string aniFolder = "Assets/Animation/NPC/";

        if (!EditorUtility.DisplayDialog("功能确认", "确定要创建NPC战斗状态下的预设吗？", "确定"))
        {
            return;
        }

        //批量创建预设
        string genPath = Application.dataPath + "/" + imgFolder;
        string[] foderPath = Directory.GetDirectories(genPath);
        List<string> listBattleName = new List<string>();
        List<string> listNormalName = new List<string>();
        string prefabNameNormal = "";
        for (int i = 0; i < foderPath.Length; i++)
        {
            string url = foderPath[i];
            int index = url.LastIndexOf("/");
            string npcID = url.Substring(index + 1, url.Length - index - 1);
            string pUrl = Application.dataPath + "/" + prefabFolder + npcID + ".prefab";

            if (npcID.IndexOf("_battle") > 0)
            {
                continue;
            }
            else
            {
                AnimationData animationData = ParseAnimationData("Assets/config/" + npcID + ".xml");
                if (animationData.dicActionData.Keys.Count == 0)
                {
                    continue;
                }
                bool isFunNpc = true;
                foreach (string key in animationData.dicActionData.Keys)
                {
                    if (key != "stand" && key != "specialstand")
                    {
                        isFunNpc = false;
                        break;
                    }
                }
                if (isFunNpc == false)
                {
                    continue;
                }
                if (File.Exists(pUrl))
                {
                    //已经创建过预设的
                    prefabNameNormal = "Assets/" + prefabFolder + npcID + ".prefab";
                    continue;
                }
                listNormalName.Add(npcID);
            }
        }
        if (string.IsNullOrEmpty(prefabNameNormal))
        {
            EditorUtility.DisplayDialog("NPC普通状态", "需要至少存在一个已经创建的NPC预设", "确定");
        }
        if (listBattleName.Count + listNormalName.Count == 0)
        {
            EditorUtility.DisplayDialog("成功", "没有可创建的怪物预设", "确定");
            return;
        }
        List<UnityEngine.Object> objList = new List<UnityEngine.Object>();
        //正常状态
        if (!string.IsNullOrEmpty(prefabNameNormal))
        {
            //复制的预设
            GameObject _prefab = AssetDatabase.LoadAssetAtPath(prefabNameNormal, typeof(GameObject)) as GameObject;
            //创建预设
            for (int i = 0; i < listNormalName.Count; i++)
            {
                string fileName = listNormalName[i];
                string npcName = fileName;

                //解析动画xml数据
                AnimationData animationData = ParseAnimationData("Assets/config/" + fileName + ".xml");
                if (animationData.dicActionData.Keys.Count == 0)
                {
                    continue;
                }
                if (animationData.dicActionData.ContainsKey("specialstand"))
                {
                    CRoleSprite roleSprite = _prefab.GetComponent<CRoleSprite>();
                    if (roleSprite != null)
                    {
                        roleSprite.m_bHasSpecialStand = true;
                    }
                }
                else
                {
                    CRoleSprite roleSprite = _prefab.GetComponent<CRoleSprite>();
                    if (roleSprite != null)
                    {
                        roleSprite.m_bHasSpecialStand = false;
                    }
                }
                CreateNormalPrefab(_prefab, imgFolder, genPath, prefabFolder, aniFolder, npcName, npcName, EmPrefabType.emPrefabType_MonsterNormal);

                //刷新进度条
                //MonoBehaviour.DestroyImmediate(tempPrefab, true);
                UpdateProgress(i, listNormalName.Count + listNormalName.Count, "创建怪物预设:" + fileName);
                //objList.Add(tempPrefab);
                AssetDatabase.SaveAssets();
            }
        }

        foreach (UnityEngine.Object obj in objList)
        {
            //GameObject.DestroyImmediate(obj, true);
        }
        objList = new List<UnityEngine.Object>();

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设创建完成！", "确定");
    }


    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/CreateRolePrefabs")]
    private static void CreateUserPrefabs()
    {
        string imgFolder = "Textures/role/";
        string prefabFolder = "Prefabs/Entity/Role/";
        string aniFolder = "Assets/Animation/Role/";
        string genPath = Application.dataPath + "/" + imgFolder;

        if (!EditorUtility.DisplayDialog("功能确认", "确定要创建玩家预设吗？", "确定"))
        {
            return;
        }

        string[] arrMetier = { "jian", "quan", "zhi" };
        string[] arrSex = { "nan", "nv" };
        string strNPrefabName = "";
        string strBPrefabName = "";
        List<ResName> listNameNormal = new List<ResName>();
        List<ResName> listNameBattle = new List<ResName>();

        //统计需要创建的预设
        for (int i = 0; i < arrMetier.Length; i++)
        {
            string strMetier = arrMetier[i];
            for (int j = 0; j < arrSex.Length; j++)
            {
                string strSex = arrSex[j];
                //普通状态
                string urlNormal = Application.dataPath + "/" + imgFolder + strMetier + "_" + strSex;
                if (Directory.Exists(urlNormal))
                {
                    string pUrl = Application.dataPath + "/" + prefabFolder + strMetier + strSex + ".prefab";
                    if (File.Exists(pUrl))
                    {
                        //已经创建过预设的
                        strNPrefabName = "Assets/" + prefabFolder + strMetier + strSex + ".prefab";
                    }
                    else
                    {
                        ResName resName = new ResName();
                        resName.m_strMetierName = strMetier;
                        resName.m_strSex = strSex;
                        listNameNormal.Add(resName);
                    }
                }
                //战斗状态
                string urlBattle = Application.dataPath + "/" + imgFolder + strMetier + "_" + strSex + "_battle";
                if (Directory.Exists(urlBattle))
                {
                    string pUrl = Application.dataPath + "/" + prefabFolder + strMetier + strSex + "_battle" + ".prefab";
                    if (File.Exists(pUrl))
                    {
                        //已经创建过预设的
                        strBPrefabName = "Assets/" + prefabFolder + strMetier + strSex + "_battle" + ".prefab";
                    }
                    else
                    {
                        ResName resName = new ResName();
                        resName.m_strMetierName = strMetier;
                        resName.m_strSex = strSex;
                        listNameBattle.Add(resName);
                    }
                }
            }
        }

        //总数量
        int nTotalNum = listNameNormal.Count + listNameBattle.Count;

        if (string.IsNullOrEmpty(strNPrefabName))
        {
            EditorUtility.DisplayDialog("角色普通状态", "需要至少存在一个已经创建的角色预设", "确定");
        }
        if (string.IsNullOrEmpty(strBPrefabName))
        {
            EditorUtility.DisplayDialog("角色战斗状态", "需要至少存在一个已经创建的角色预设", "确定");
        }
        if (string.IsNullOrEmpty(strNPrefabName) && string.IsNullOrEmpty(strBPrefabName))
        {
            return;
        }
        if (nTotalNum == 0)
        {
            EditorUtility.DisplayDialog("失败", "没有可创建的角色预设", "确定");
            return;
        }
        //战斗状态
        if (!string.IsNullOrEmpty(strBPrefabName))
        {
            //复制的龙骨预设
            GameObject _prefab = AssetDatabase.LoadAssetAtPath(strBPrefabName, typeof(GameObject)) as GameObject;
            List<UnityEngine.Object> objList = new List<UnityEngine.Object>();
            //创建预设
            for (int i = 0; i < listNameBattle.Count; i++)
            {
                ResName resName = listNameBattle[i];
                string npcName = resName.m_strMetierName + resName.m_strSex + "_battle";
                string animationName = resName.m_strMetierName + "_" + resName.m_strSex;

                CreateBattlePrefab(_prefab, imgFolder, genPath, prefabFolder, aniFolder, npcName, animationName);

                ////创建预设，保存预设，刷新进度条
                //Object prefab = PrefabUtility.CreateEmptyPrefab(url);
                //tempPrefab = PrefabUtility.ReplacePrefab((GameObject)tempPrefab, prefab);
                ////MonoBehaviour.DestroyImmediate(tempPrefab, true);
                UpdateProgress(i, nTotalNum, "创建角色预设:" + npcName);
                //objList.Add(tempPrefab);
                AssetDatabase.SaveAssets();
            }
            foreach (UnityEngine.Object obj in objList)
            {
                //GameObject.DestroyImmediate(obj, true);
            }
            objList = new List<UnityEngine.Object>();
        }
        //正常状态
        if (!string.IsNullOrEmpty(strNPrefabName))
        {
            //复制的龙骨预设
            GameObject _prefab = AssetDatabase.LoadAssetAtPath(strNPrefabName, typeof(GameObject)) as GameObject;
            List<UnityEngine.Object> objList = new List<UnityEngine.Object>();
            //创建预设
            for (int i = 0; i < listNameNormal.Count; i++)
            {
                ResName resName = listNameNormal[i];
                string npcName = resName.m_strMetierName + resName.m_strSex;
                string animationName = resName.m_strMetierName + "_" + resName.m_strSex;

                CreateNormalPrefab(_prefab, imgFolder, genPath, prefabFolder, aniFolder, npcName, animationName, EmPrefabType.emPrefabType_RoleNormal);

                ////创建预设，保存预设，刷新进度条
                //Object prefab = PrefabUtility.CreateEmptyPrefab(url);
                //tempPrefab = PrefabUtility.ReplacePrefab((GameObject)tempPrefab, prefab);
                ////MonoBehaviour.DestroyImmediate(tempPrefab, true);
                UpdateProgress(i, nTotalNum, "创建角色预设:" + npcName);
                //objList.Add(tempPrefab);
                AssetDatabase.SaveAssets();
            }
            foreach (UnityEngine.Object obj in objList)
            {
                //GameObject.DestroyImmediate(obj, true);
            }
            objList = new List<UnityEngine.Object>();
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设创建完成！", "确定");
    }

    private static void CreateNormalPrefab(GameObject _prefab, string imgFolder, string genPath, string prefabFolder, string aniFolder, string npcName, string animationName, EmPrefabType emPrefabType)
    {
        string url = "Assets/" + prefabFolder + npcName + ".prefab";
        GameObject prefabObj = AssetDatabase.LoadAssetAtPath(url, typeof(GameObject)) as GameObject;
        UnityEngine.Object tempPrefab = PrefabUtility.CreateEmptyPrefab(url);
        tempPrefab = PrefabUtility.InstantiatePrefab(_prefab);
        tempPrefab.name = npcName;

        GameObject gameObj = (GameObject)tempPrefab;

        //解析动画xml数据
        AnimationData animationData = ParseAnimationData("Assets/config/" + animationName + ".xml");
        //更新Sprite的锚点
        UpdateDirectorySpritePivot(animationData, genPath + animationName);

        //设置预设里默认头顶和胸部位置，以stand动作里的位置为默认值
        ActionData actData = animationData.dicActionData["stand"];

        //canvas
        GameObject canvasObj = ((GameObject)tempPrefab).transform.FindChild("Canvas").gameObject;
        if (canvasObj != null)
        {
            Canvas canvas = canvasObj.GetComponent<Canvas>();
            if (canvas != null)
            {
                RectTransform rtf = canvas.GetComponent<RectTransform>();
                rtf.localPosition = new Vector3(actData.fHeadX, actData.fHeadY, 0);
            }
        }

        //创建动画
        UnityEditor.Animations.AnimatorController animatorController = DoCreateAnimationAssets("/" + imgFolder + animationName + "/", animationData, aniFolder, emPrefabType);

        SpriteRenderer spr = gameObj.GetComponent<SpriteRenderer>();
        if (spr == null)
        {
            spr = gameObj.AddComponent<SpriteRenderer>();
        }
        spr.sprite = AssetDatabase.LoadAssetAtPath<Sprite>("Assets/" + imgFolder + animationName + "/stand_01.png");

        Animator animator = gameObj.GetComponent<Animator>();
        if (animator == null)
        {
            animator = gameObj.AddComponent<Animator>();
        }
        animator.runtimeAnimatorController = animatorController;

        //创建预设，保存预设，刷新进度条
        UnityEngine.Object prefab = PrefabUtility.CreateEmptyPrefab(url);
        tempPrefab = PrefabUtility.ReplacePrefab(gameObj, prefab);
    }

    //创建战斗状态下的预设
    private static void CreateBattlePrefab(GameObject _prefab, string imgFolder, string genPath, string prefabFolder, string aniFolder, string npcName, string animationName)
    {
        string url = "Assets/" + prefabFolder + npcName + ".prefab";
        GameObject prefabObj = AssetDatabase.LoadAssetAtPath(url, typeof(GameObject)) as GameObject;
        UnityEngine.Object tempPrefab = PrefabUtility.CreateEmptyPrefab(url);
        tempPrefab = PrefabUtility.InstantiatePrefab(_prefab);
        tempPrefab.name = npcName;

        //解析动画xml数据
        AnimationData animationData = ParseAnimationData("Assets/config/" + animationName + "_battle.xml");
        //更新Sprite的锚点
        UpdateDirectorySpritePivot(animationData, genPath + animationName + "_battle/");

        //设置头顶和胸部位置
        CBattleRole battleRole = ((GameObject)tempPrefab).GetComponent<CBattleRole>();
        if (battleRole == null)
        {
            battleRole = ((GameObject)tempPrefab).AddComponent<CBattleRole>();
        }
        battleRole.m_nAttackDistance = animationData.m_nAttackDistance; //攻击距离
        battleRole.m_arrCanvasPos = new Vector2[(int)EmActionType.emActionMaxNum];
        battleRole.m_arrChestPos = new Vector2[(int)EmActionType.emActionMaxNum];
        foreach (string key in animationData.dicActionData.Keys)
        {
            ActionData actionData = animationData.dicActionData[key];
            int nIndex = GetIndexByActionName(key);
            if (nIndex == -1)
            {
                continue;
            }
            battleRole.m_arrCanvasPos[nIndex] = new Vector2(actionData.fHeadX, actionData.fHeadY);
            battleRole.m_arrChestPos[nIndex] = new Vector2(actionData.fChestX, actionData.fChestY);
        }
        //设置预设里默认头顶和胸部位置，以stand动作里的位置为默认值
        ActionData standData = animationData.dicActionData["stand"];
        ActionData actData = standData;
        actData.nFrameNum = actData.keyFrame = 0;
        animationData.dicActionData.Add("run", actData);

        actData = standData;
        actData.nFrameNum = actData.keyFrame = 0;
        animationData.dicActionData.Add("back", actData);

        GameObject chestObj = ((GameObject)tempPrefab).transform.FindChild("chestPos").gameObject;
        if (chestObj == null)
        {
            chestObj = new GameObject("chestPos");
            chestObj.transform.SetParent(((GameObject)tempPrefab).transform, false);
        }
        chestObj.transform.localPosition = new Vector3(standData.fChestX, standData.fChestY, 0);

        //canvas
        GameObject canvasObj = ((GameObject)tempPrefab).transform.FindChild("Canvas").gameObject;
        if (canvasObj != null)
        {
            Canvas canvas = canvasObj.GetComponent<Canvas>();
            if (canvas != null)
            {
                RectTransform rtf = canvas.GetComponent<RectTransform>();
                rtf.localPosition = new Vector3(standData.fHeadX, standData.fHeadY, 0);
            }
        }

        GameObject bodySprite = ((GameObject)tempPrefab);//.transform.FindChild("bodySprite").gameObject;
        if (bodySprite != null)
        {
            //创建动画
            UnityEditor.Animations.AnimatorController animatorController = DoCreateAnimationAssets("/" + imgFolder + animationName + "_battle/", animationData, aniFolder, EmPrefabType.emPrefabType_RoleBattle);

            SpriteRenderer spr = bodySprite.GetComponent<SpriteRenderer>();
            if (spr == null)
            {
                spr = bodySprite.AddComponent<SpriteRenderer>();
            }
            spr.sprite = AssetDatabase.LoadAssetAtPath<Sprite>("Assets/" + imgFolder + animationName + "_battle/stand_01.png");

            Animator animator = bodySprite.GetComponent<Animator>();
            if (animator == null)
            {
                animator = bodySprite.AddComponent<Animator>();
            }
            animator.runtimeAnimatorController = animatorController;
        }

        //创建预设，保存预设，刷新进度条
        UnityEngine.Object prefab = PrefabUtility.CreateEmptyPrefab(url);
        tempPrefab = PrefabUtility.ReplacePrefab((GameObject)tempPrefab, prefab);
    }

    static int GetIndexByActionName(string actionName)
    {
        if (actionName == "stand")
        {
            return (int)EmActionType.emStand;
        }
        else if (actionName == "beating")
        {
            return (int)EmActionType.emBeating;
        }
        else if (actionName == "attack")
        {
            return (int)EmActionType.emAttack;
        }
        else if (actionName == "skillattack")
        {
            return (int)EmActionType.emSkillAttack;
        }
        else if (actionName == "run")
        {
            return (int)EmActionType.emRun;
        }
        return -1;
    }

    //解析动画xml配置
    static AnimationData ParseAnimationData(string url)
    {
        AnimationData animationData = new AnimationData();
        animationData.dicActionData = new Dictionary<string, ActionData>();

        TextAsset xmlAsset = AssetDatabase.LoadAssetAtPath<TextAsset>(url);
        if (xmlAsset == null)
        {
            MonoBehaviour.print("缺少XML文件:" + url);
            return animationData;
        }
        //MonoBehaviour.print("加载文件:" + url);
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(xmlAsset.text);
        XmlNode xNode = xmlDoc.SelectSingleNode("role");
        if (xNode == null)
        {
            return animationData;
        }
        if (xNode.Attributes["attack_distance"] != null)
        {
            animationData.m_nAttackDistance = int.Parse(xNode.Attributes["attack_distance"].Value);
        }

        XmlNode xmlNode = xNode.SelectSingleNode("action");
        if (xmlNode != null)
        {
            foreach (XmlNode childNode in xmlNode.ChildNodes)
            {
                ActionData actData = ParseActionData(childNode);
                animationData.dicActionData.Add(childNode.Name, actData);
            }
        }

        animationData.talkData = new TalkData();
        xmlNode = xNode.SelectSingleNode("talkData");
        if (xmlNode != null)
        {
            foreach (XmlNode childNode in xmlNode.ChildNodes)
            {
                if (childNode.Name == "leftPos")
                {
                    animationData.talkData.m_vecLeftTalkPos = new Vector2(float.Parse(xmlNode.Attributes["x"].Value), float.Parse(xmlNode.Attributes["y"].Value));
                }
                else if (childNode.Name == "rightPos")
                {
                    animationData.talkData.m_vecRightTalkPos = new Vector2(float.Parse(xmlNode.Attributes["x"].Value), float.Parse(xmlNode.Attributes["y"].Value));
                }
                else if (childNode.Name == "headIcon")
                {
                    animationData.talkData.strHeadIconName = xmlNode.Attributes["headIcon"].Value;
                }
                else if (childNode.Name == "content")
                {
                    animationData.talkData.m_dicTalkData = new Dictionary<int, List<string>>();
                    foreach (XmlNode content in childNode.ChildNodes)
                    {
                        int nType = int.Parse(content.Attributes["Type"].Value);
                        string strContent = content.Attributes["Value"].Value;
                        List<string> list = animationData.talkData.m_dicTalkData[nType];
                        if (list == null)
                        {
                            list = new List<string>();
                            animationData.talkData.m_dicTalkData[nType] = list;
                        }
                        list.Add(strContent);
                    }
                }
            }
        }
        return animationData;
    }
    static ActionData ParseActionData(XmlNode xmlNode)
    {
        ActionData actData = new ActionData();
        actData.nFrameNum = int.Parse(xmlNode.Attributes["frame_num"].Value);
        actData.nFrameInterval = int.Parse(xmlNode.Attributes["frame_interval"].Value);
        actData.keyFrame = int.Parse(xmlNode.Attributes["key_frame"].Value);
        actData.nPivotX = int.Parse(xmlNode.Attributes["pivotx"].Value);
        actData.nPivotY = int.Parse(xmlNode.Attributes["pivoty"].Value);
        actData.fHeadX = int.Parse(xmlNode.Attributes["headx"].Value) * 0.01f;
        actData.fHeadY = int.Parse(xmlNode.Attributes["heady"].Value) * 0.01f;
        actData.fChestX = int.Parse(xmlNode.Attributes["chestx"].Value) * 0.01f;
        actData.fChestY = int.Parse(xmlNode.Attributes["chesty"].Value) * 0.01f;
        return actData;
    }

    //刷新文件夹下Sprite的锚点坐标
    static void UpdateDirectorySpritePivot(AnimationData animationData, string path)
    {
        DirectoryInfo dictorys = new DirectoryInfo(path);
        //查找所有图片
        FileInfo[] images = dictorys.GetFiles("*.png");
        Dictionary<string, List<FileInfo>> dic = new Dictionary<string, List<FileInfo>>();
        for (int i = 0; i < images.Length; i++)
        {
            FileInfo fileInfo = images[i];
            int index = fileInfo.Name.IndexOf("_");
            string fileName = fileInfo.Name.Substring(0, index);
            List<FileInfo> list = null;
            if (dic.ContainsKey(fileName))
            {
                list = dic[fileName];
            }
            else
            {
                list = new List<FileInfo>();
                dic.Add(fileName, list);
            }
            list.Add(fileInfo);
        }
        foreach (string key in dic.Keys)
        {
            if (animationData.dicActionData.ContainsKey(key))
            {
                ActionData actionData = animationData.dicActionData[key];

                List<FileInfo> list = dic[key];
                for (int i = 0; i < list.Count; i++)
                {
                    UpdateSpritePivot(DataPathToAssetPath(list[i].FullName), actionData.nPivotX, actionData.nPivotY);
                }
            }
        }
    }

    /**
     * 刷新Sprite的锚点
     * url:Sprite的路径
     * nPivotX,nPivotY:锚点坐标(从xml里解析到的，U3D里需要转换一下)
     */
    static void UpdateSpritePivot(string url, float nPivotX, float nPivotY)
    {
        Sprite sp = AssetDatabase.LoadAssetAtPath<Sprite>(url);
        float nWidth = sp.texture.width;
        float nHeight = sp.texture.height;
        float nPx = nPivotX / nWidth * 1.0f;
        float nPy = (nHeight - nPivotY) / nHeight * 1.0f;

        TextureImporter texImporter = AssetImporter.GetAtPath(url) as TextureImporter;
        TextureImporterSettings tis = new TextureImporterSettings();
        texImporter.ReadTextureSettings(tis);
        if (tis.spriteAlignment == (int)SpriteAlignment.Custom)
        {
            if (tis.spritePivot == new Vector2(nPx, nPy))
            {
                return;
            }
        }
        tis.spriteAlignment = (int)SpriteAlignment.Custom;  //设置对齐方式
        tis.spritePivot = new Vector2(nPx, nPy);            //设置sprite的锚点
        texImporter.SetTextureSettings(tis);                //将这个设置应用到这个Sprite上
        AssetDatabase.ImportAsset(url);
    }

    /**
     * 刷新进度条
     * desc:进度条上的提示内容
     */
    static void UpdateProgress(int progress, int progressMax, string desc)
    {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }

    /**
     * 创建动画
     * url:用于创建序列帧动画图集的路径
     * animationData：动画数据(从本地xml里读取，解析到的)
     * aniFolder:相关动画文件(Animation和Animation Controller)存放的文件夹路径
     * emType:预设类型，不同类型会创建不同的动画以及动画触发条件
     */
    static UnityEditor.Animations.AnimatorController DoCreateAnimationAssets(string url, AnimationData animationData, string aniFolder, EmPrefabType emType)
    {
        DirectoryInfo dictorys = new DirectoryInfo(Application.dataPath + url);
        string npcName = dictorys.Name;
        System.IO.Directory.CreateDirectory(aniFolder + npcName);   //创建对应的文件夹

        bool bCreateRunBack = false;
        if (npcName.IndexOf("_battle") > 0)
        {
            bCreateRunBack = true;
        }

        //创建.anim动画文件
        BuildAnimationClip(dictorys, animationData, aniFolder, bCreateRunBack);

        string aniUrl = aniFolder + npcName + "/" + npcName;
        string strName = npcName;
        if (npcName.IndexOf("_battle") >= 0)
        {
            strName = npcName.Substring(0, npcName.IndexOf("_battle"));
        }

        //创建animationController文件
        UnityEditor.Animations.AnimatorController animatorController = UnityEditor.Animations.AnimatorController.CreateAnimatorControllerAtPath(aniUrl + ".controller");

        //创建4个state(stand,beating,attack,run)
        var rootStateMachine = animatorController.layers[0].stateMachine;
        var state_stand = rootStateMachine.AddState(npcName + "@stand");
        //设置对应的动作
        state_stand.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@stand.anim");
        //root-->stand
        rootStateMachine.AddEntryTransition(state_stand);
        rootStateMachine.RemoveEntryTransition(rootStateMachine.entryTransitions[0]);
        //默认状态为stand
        rootStateMachine.defaultState = state_stand;

        if (emType == EmPrefabType.emPrefabType_MonsterBattle)
        {
            //添加触发条件，attack和beating
            animatorController.AddParameter("attack", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("beating", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("run", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("back", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("stand", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("dead", UnityEngine.AnimatorControllerParameterType.Trigger);

            var state_attack = rootStateMachine.AddState(npcName + "@attack");
            var state_beating = rootStateMachine.AddState(npcName + "@beating");
            var state_run = rootStateMachine.AddState(npcName + "@run");
            var state_dead = rootStateMachine.AddState(npcName + "@dead");
            var state_back = rootStateMachine.AddState(npcName + "@back");

            //设置对应的动作
            state_attack.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@attack.anim");
            state_beating.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@beating.anim");
            state_run.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@run.anim");
            state_back.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@back.anim");
            state_dead.motion = AssetDatabase.LoadAssetAtPath<Motion>("Assets/Animation/effect/battle/dead@FadeOut.anim");

            //stand <=> attack
            UnityEditor.Animations.AnimatorStateTransition animatorStateTransition = state_stand.AddTransition(state_attack);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "attack");
            state_attack.AddTransition(state_stand, true);

            //stand <=> beating
            animatorStateTransition = state_stand.AddTransition(state_beating);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "beating");
            state_beating.AddTransition(state_stand, true);

            //stand <=> run
            animatorStateTransition = state_stand.AddTransition(state_run);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "run");
            animatorStateTransition = state_run.AddTransition(state_stand);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "stand");

            //stand <=> back
            animatorStateTransition = state_stand.AddTransition(state_back);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "back");
            animatorStateTransition = state_back.AddTransition(state_stand);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "stand");

            //stand => dead
            animatorStateTransition = state_stand.AddTransition(state_dead);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "dead");
        }
        else if (emType == EmPrefabType.emPrefabType_RoleBattle)
        {
            //添加触发条件，attack和beating,skillattack
            animatorController.AddParameter("attack", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("beating", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("skillattack", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("run", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("back", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("stand", UnityEngine.AnimatorControllerParameterType.Trigger);
            animatorController.AddParameter("dead", UnityEngine.AnimatorControllerParameterType.Trigger);

            var state_attack = rootStateMachine.AddState(npcName + "@attack");
            var state_beating = rootStateMachine.AddState(npcName + "@beating");
            var state_skillattack = rootStateMachine.AddState(npcName + "@skillattack");
            var state_run = rootStateMachine.AddState(npcName + "@run");
            var state_dead = rootStateMachine.AddState(npcName + "@dead");
            var state_back = rootStateMachine.AddState(npcName + "@back");

            //设置对应的动作
            state_attack.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@attack.anim");
            state_beating.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@beating.anim");
            state_skillattack.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@skillattack.anim");
            state_run.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@run.anim");
            state_back.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@back.anim");
            state_dead.motion = AssetDatabase.LoadAssetAtPath<Motion>("Assets/Animation/effect/battle/dead@FadeOut.anim");

            //stand <=> attack
            UnityEditor.Animations.AnimatorStateTransition animatorStateTransition = state_stand.AddTransition(state_attack);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "attack");
            state_attack.AddTransition(state_stand, true);

            //stand <=> beating
            animatorStateTransition = state_stand.AddTransition(state_beating);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "beating");
            state_beating.AddTransition(state_stand, true);

            //stand <=> skillattack
            animatorStateTransition = state_stand.AddTransition(state_skillattack);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "skillattack");
            state_skillattack.AddTransition(state_stand, true);

            //stand <=> run
            animatorStateTransition = state_stand.AddTransition(state_run);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "run");
            animatorStateTransition = state_run.AddTransition(state_stand);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "stand");

            //stand <=> back
            animatorStateTransition = state_stand.AddTransition(state_back);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "back");
            animatorStateTransition = state_back.AddTransition(state_stand);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "stand");

            //stand => dead
            animatorStateTransition = state_stand.AddTransition(state_dead);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "dead");
        }
        else if (emType == EmPrefabType.emPrefabType_RoleNormal)
        {
            //添加触发条件，run
            animatorController.AddParameter("run", UnityEngine.AnimatorControllerParameterType.Trigger);

            var state_run = rootStateMachine.AddState(npcName + "@run");
            //设置对应的动作
            state_run.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@run.anim");

            //stand <=> run
            UnityEditor.Animations.AnimatorStateTransition animatorStateTransition = state_stand.AddTransition(state_run);
            animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "run");
            state_run.AddTransition(state_stand, true);
        }
        else if (emType == EmPrefabType.emPrefabType_MonsterNormal)
        {
            if (animationData.dicActionData.ContainsKey("run"))
            {
                //添加触发条件，run
                animatorController.AddParameter("run", UnityEngine.AnimatorControllerParameterType.Trigger);

                var state_run = rootStateMachine.AddState(npcName + "@run");
                //设置对应的动作
                state_run.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@run.anim");

                //stand <=> run
                UnityEditor.Animations.AnimatorStateTransition animatorStateTransition = state_stand.AddTransition(state_run);
                animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "run");
                state_run.AddTransition(state_stand, true);
            }
            //特殊站立
            if (animationData.dicActionData.ContainsKey("specialstand"))
            {
                //添加触发条件，specialstand
                animatorController.AddParameter("specialstand", UnityEngine.AnimatorControllerParameterType.Trigger);

                var state_specialstand = rootStateMachine.AddState(npcName + "@specialstand");
                //设置对应的动作
                state_specialstand.motion = AssetDatabase.LoadAssetAtPath<Motion>(aniUrl + "@specialstand.anim");

                //stand <=> specialstand
                UnityEditor.Animations.AnimatorStateTransition animatorStateTransition = state_stand.AddTransition(state_specialstand);
                animatorStateTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.If, 0, "specialstand");
                state_specialstand.AddTransition(state_stand, true);
            }
        }
        return animatorController;
    }

    //创建.anim动画文件
    static void BuildAnimationClip(DirectoryInfo dictorys, AnimationData animationData, string aniFolder, bool bCreateRunBack)
    {
        string animationName = dictorys.Name;

        //查找所有图片
        FileInfo[] images = dictorys.GetFiles("*.png");
        Dictionary<string, List<FileInfo>> dic = new Dictionary<string, List<FileInfo>>();

        for (int i = 0; i < images.Length; i++)
        {
            FileInfo fileInfo = images[i];
            int index = fileInfo.Name.IndexOf("_");
            string fileName = fileInfo.Name.Substring(0, index);
            List<FileInfo> list = null;
            if (dic.ContainsKey(fileName))
            {
                list = dic[fileName];
            }
            else
            {
                list = new List<FileInfo>();
                dic.Add(fileName, list);
            }
            list.Add(fileInfo);
        }
        if (bCreateRunBack)
        {
            if (dic.ContainsKey("run") == false)
            {
                dic.Add("run", new List<FileInfo>());
            }
            if (dic.ContainsKey("back") == false)
            {
                dic.Add("back", new List<FileInfo>());
            }
        }

        foreach (string key in dic.Keys)
        {
            if (!animationData.dicActionData.ContainsKey(key))
            {
                continue;
            }
            ActionData actData = animationData.dicActionData[key];

            List<FileInfo> list = dic[key];
            AnimationClip clip = new AnimationClip();
            //AnimationUtility.SetAnimationType(clip, ModelImporterAnimationType.Generic);
            EditorCurveBinding curveBinding = new EditorCurveBinding();

            curveBinding.type = typeof(SpriteRenderer);
            curveBinding.path = "";
            curveBinding.propertyName = "m_Sprite";

            ObjectReferenceKeyframe[] keyFrames = new ObjectReferenceKeyframe[list.Count];

            //动画帧率
            clip.frameRate = (int)(1000 / 40 / actData.nFrameInterval);

            //动画长度是按秒为单位
            float frameTime = 1.0f / clip.frameRate;

            for (int i = 0; i < list.Count; i++)
            {
                Sprite sprite = AssetDatabase.LoadAssetAtPath<Sprite>(DataPathToAssetPath(list[i].FullName));
                keyFrames[i] = new ObjectReferenceKeyframe();
                keyFrames[i].time = frameTime * i;// (float)((int)(frameTime * i * 100) * 0.01f);
                keyFrames[i].value = sprite;
                //MonoBehaviour.print(key + "_" + i.ToString() + "   " + keyFrames[i].time);
            }

            //只有攻击，被攻击，技能攻击添加关键帧事件和结束帧事件
            if (key == "attack" || key == "beating" || key == "skillattack")
            {
                if (actData.keyFrame == 0)
                {
                    actData.keyFrame = 1;
                }
                string strKeyEventName = "";
                string strEndEventName = "";
                if (key == "attack" || key == "skillattack")
                {
                    strKeyEventName = "OnAttackKeyFrameEvent";
                    strEndEventName = "OnAttackEndEvent";
                }
                else
                {
                    strKeyEventName = "OnBeatKeyFrameEvent";
                    strEndEventName = "OnBeatEndEvent";
                }


                List<AnimationEvent> events = new List<AnimationEvent>(2);
                if (actData.keyFrame > 0 && actData.keyFrame < keyFrames.Length)
                {
                    ObjectReferenceKeyframe objRefKey = keyFrames[actData.keyFrame - 1];
                    AnimationEvent keyEvent = new AnimationEvent();
                    keyEvent.time = objRefKey.time;//(float)actData.keyFrame / (float)10;
                    keyEvent.functionName = strKeyEventName;//函数名，必须该GameObject绑定脚本里包含该函数，否则会报错
                    events.Add(keyEvent);
                }

                // 设置结束帧事件
                ObjectReferenceKeyframe objRefEnd = keyFrames[keyFrames.Length - 1];
                AnimationEvent endEvent = new AnimationEvent();
                endEvent.time = objRefEnd.time;//(float)actData.keyFrame / (float)10;
                endEvent.functionName = strEndEventName;//函数名，必须该GameObject绑定脚本里包含该函数，否则会报错
                events.Add(endEvent);
                AnimationUtility.SetAnimationEvents(clip, events.ToArray());
            }


            if (key == "stand")
            {
                AnimationClipSettings clipSettings = AnimationUtility.GetAnimationClipSettings(clip);
                clipSettings.loopTime = true;
                AnimationUtility.SetAnimationClipSettings(clip, clipSettings);
            }

            AnimationUtility.SetObjectReferenceCurve(clip, curveBinding, keyFrames);
            AssetDatabase.CreateAsset(clip, aniFolder + animationName + "/" + animationName + "@" + key + ".anim");
            AssetDatabase.SaveAssets();
        }
    }
    public static string DataPathToAssetPath(string path)
    {
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            return path.Substring(path.IndexOf("Assets\\"));
        }
        else
        {
            return path.Substring(path.IndexOf("Assets/"));
        }
    }

    static void BuildRunBackAnimationClip(DirectoryInfo dictorys, AnimationData animationData, string aniFolder)
    {
        string animationName = dictorys.Name;

        //查找所有图片
        FileInfo[] images = dictorys.GetFiles("*.png");
        Dictionary<string, List<FileInfo>> dic = new Dictionary<string, List<FileInfo>>();

        for (int i = 0; i < images.Length; i++)
        {
            FileInfo fileInfo = images[i];
            int index = fileInfo.Name.IndexOf("_");
            string fileName = fileInfo.Name.Substring(0, index);
            List<FileInfo> list = null;
            if (dic.ContainsKey(fileName))
            {
                list = dic[fileName];
            }
            else
            {
                list = new List<FileInfo>();
                dic.Add(fileName, list);
            }
            list.Add(fileInfo);
        }

        foreach (string key in dic.Keys)
        {
            if (!animationData.dicActionData.ContainsKey(key))
            {
                continue;
            }
            ActionData actData = animationData.dicActionData[key];

            List<FileInfo> list = dic[key];
            AnimationClip clip = new AnimationClip();
            EditorCurveBinding curveBinding = new EditorCurveBinding();

            curveBinding.type = typeof(SpriteRenderer);
            curveBinding.path = "";
            curveBinding.propertyName = "m_Sprite";

            ObjectReferenceKeyframe[] keyFrames = new ObjectReferenceKeyframe[list.Count];

            //动画帧率
            clip.frameRate = (int)(1000 / 40 / actData.nFrameInterval);

            //动画长度是按秒为单位
            float frameTime = 1.0f / clip.frameRate;

            for (int i = 0; i < list.Count; i++)
            {
                Sprite sprite = AssetDatabase.LoadAssetAtPath<Sprite>(DataPathToAssetPath(list[i].FullName));
                keyFrames[i] = new ObjectReferenceKeyframe();
                keyFrames[i].time = frameTime * i;
                keyFrames[i].value = sprite;
            }

            AnimationUtility.SetObjectReferenceCurve(clip, curveBinding, keyFrames);
            AssetDatabase.CreateAsset(clip, aniFolder + animationName + "/" + animationName + "@" + key + ".anim");
            AssetDatabase.SaveAssets();
        }
    }

    [MenuItem("Tools/Prefabs/ModifyNpcPrefabs")]
    private static void ModifyNpcPrefabs()
    {
        // 修改实体动画文件，攻击、技能攻击、被攻击动画增加关键帧和结束帧
        string strNpcAnimFolder = "Assets/Animation/NPC/";
        //string strFullPath = Application.dataPath + "/" + strNpcAnimFolder;
        string[] foderPath = Directory.GetDirectories(strNpcAnimFolder);


        for (int i = 0; i < foderPath.Length; i++)
        {
            string url = foderPath[i];
            int index = url.LastIndexOf("/");
            string strSubFolder = url.Substring(index + 1, url.Length - index - 1);
            //string pUrl = "Assets/" + prefabFolder + npcID;

            //GameObject prefabObj = AssetDatabase.LoadAssetAtPath(pUrl, typeof(GameObject)) as GameObject;
            // 获得子文件夹下的所有文件
            //Debug.Log(strSubFolder);
            UpdateProgress(i + 1, foderPath.Length, strSubFolder + "  Animation");
            DirectoryInfo dictorys = new DirectoryInfo("Assets/Animation/NPC/" + strSubFolder);
            FileInfo[] arrFiles = dictorys.GetFiles("*.anim");
            for (int j = 0; j < arrFiles.Length; j++)
            {
                string strAnimDir = "Assets/Animation/NPC/" + strSubFolder + "/" + arrFiles[j].Name;
                AnimationClip clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(strAnimDir);

                EditorCurveBinding[] arrEditorBinding = AnimationUtility.GetObjectReferenceCurveBindings(clip);
                if (arrEditorBinding.Length <= 0)
                {
                    continue;
                }
                ObjectReferenceKeyframe[] keyFrames = AnimationUtility.GetObjectReferenceCurve(clip, arrEditorBinding[0]);
                if (keyFrames.Length <= 0)
                {
                    continue;
                }
                //动画长度是按秒为单位
                float frameTime = 1.0f / clip.frameRate;
                for (int k = 0; k < keyFrames.Length; k++)
                {
                    keyFrames[k].time = k * frameTime;
                }
                AnimationUtility.SetObjectReferenceCurve(clip, arrEditorBinding[0], keyFrames);
                int nStartIndex = arrFiles[j].Name.LastIndexOf("@") + 1;
                int nEndIndex = arrFiles[j].Name.LastIndexOf(".");
                string strAction = arrFiles[j].Name.Substring(nStartIndex, nEndIndex - nStartIndex);
                if (strAction != "attack" && strAction != "skillattack" && strAction != "beating")
                {
                    continue;
                }
                AnimationData tmpActionData = ParseAnimationData("Assets/config/" + strSubFolder + ".xml");
                if (!tmpActionData.dicActionData.ContainsKey(strAction))
                {
                    continue;
                }
                ActionData actData = tmpActionData.dicActionData[strAction];

                // 要修改帧时间
                if (actData.keyFrame == 0 || actData.keyFrame > keyFrames.Length)
                {
                    actData.keyFrame = 1;
                }
                string strKeyEventName = "";
                string strEndEventName = "";
                if (strAction == "attack" || strAction == "skillattack")
                {
                    strKeyEventName = "OnAttackKeyFrameEvent";
                    strEndEventName = "OnAttackEndEvent";
                }
                else
                {
                    strKeyEventName = "OnBeatKeyFrameEvent";
                    strEndEventName = "OnBeatEndEvent";
                }


                AnimationEvent[] arrEvent = new AnimationEvent[2];

                ObjectReferenceKeyframe objRefKey = keyFrames[actData.keyFrame - 1];
                arrEvent[0] = new AnimationEvent();
                arrEvent[0].time = objRefKey.time;//(float)actData.keyFrame / (float)10;
                arrEvent[0].functionName = strKeyEventName;//函数名，必须该GameObject绑定脚本里包含该函数，否则会报错

                // 设置结束帧事件
                ObjectReferenceKeyframe objRefEnd = keyFrames[keyFrames.Length - 1];
                arrEvent[1] = new AnimationEvent();
                arrEvent[1].time = objRefEnd.time;//(float)actData.keyFrame / (float)10;
                arrEvent[1].functionName = strEndEventName;//函数名，必须该GameObject绑定脚本里包含该函数，否则会报错
                AnimationUtility.SetAnimationEvents(clip, arrEvent);
            }
        }

        AssetDatabase.SaveAssets();
        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设修改完成！", "确定");
    }

    [MenuItem("Tools/Prefabs/Create Bat SkillPrefabs From Xml")]
    private static void CreateBatSkillPrefabsFromXml()
    {
        // 根据技能配置文件
        string strNpcAnimFolder = "Assets/Resources/config/effect/skill/";
        string[] foderPath = Directory.GetFiles(strNpcAnimFolder, "*.xml");

        for (int i = 0; i < foderPath.Length; i++)
        {
            string strFileName = foderPath[i];
            int index = strFileName.LastIndexOf("/");
            string strSubFolder = strFileName.Substring(index + 1, strFileName.Length - index - 1);
            index = strSubFolder.IndexOf(".");
            string strSkillName = strSubFolder.Substring(0, index);
            // 判断是否有此预设了
            if (File.Exists("Assets/Resources/Prefabs/effect/skill/" + strSkillName + ".prefab"))
            {
                continue;
            }
            UpdateProgress(i + 1, foderPath.Length, "  skill : " + strSkillName);
            // 解析技能配置文件   
            CEffectConfigData effectData = ParseSkillData("Assets/Resources/config/effect/skill/" + strSubFolder);
            if (effectData == null)
            {
                EditorUtility.DisplayDialog("失败", "解析技能" + strSkillName + "配置文件失败", "确定");
                EditorUtility.ClearProgressBar();
                return;
            }



            // 判断是否有此图片资源
            Sprite sp = AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Resources/images/effect/skill/" + strSkillName + "/01.png");
            if (sp == null)
            {
                EditorUtility.DisplayDialog("失败", "无此技能" + strSkillName + "图片资源", "确定");
                EditorUtility.ClearProgressBar();
                return;
            }
            GameObject skillObject = new GameObject(strSkillName);
            SpriteRenderer spRender = skillObject.AddComponent<SpriteRenderer>();
            spRender.sprite = sp;
            spRender.sortingLayerName = "effectLayer";
            string strSkillAnimaPath = "Assets/Resources/Animation/effect/skill/" + strSkillName + "/";
            System.IO.Directory.CreateDirectory(strSkillAnimaPath);
            // 创建动画文件
            CreateSkillAnimationClip(strSkillName, effectData.m_nFrameInterval, effectData.m_nFrameKey, effectData.m_nPivotx, effectData.m_nPivoty, effectData.m_bLoop);
            // 创建动画控制文件
            Animator am = skillObject.AddComponent<Animator>();
            UnityEditor.Animations.AnimatorController animatorController = UnityEditor.Animations.AnimatorController.CreateAnimatorControllerAtPath(strSkillAnimaPath + "skill_" + strSkillName + ".controller");
            AnimatorStateMachine rootStateMachine = animatorController.layers[0].stateMachine;
            AnimatorState animState = rootStateMachine.AddState("skill@" + strSkillName);
            //设置对应的动作
            animState.motion = AssetDatabase.LoadAssetAtPath<Motion>(strSkillAnimaPath + "skill@" + strSkillName + ".anim");
            //root-->stand
            rootStateMachine.AddEntryTransition(animState);
            rootStateMachine.RemoveEntryTransition(rootStateMachine.entryTransitions[0]);
            //默认状态为stand
            rootStateMachine.defaultState = animState;
            am.runtimeAnimatorController = animatorController;
            //增加技能脚本组件
            CSkillSprite skill = skillObject.AddComponent<CSkillSprite>();
            if (effectData.m_strAlign == "scene")
            {
                skill.m_eSkillPos = EmSkillPos.emAlign_Scene;
            }
            else if (effectData.m_strAlign == "bottom")
            {
                skill.m_eSkillPos = EmSkillPos.emAlign_RoleFoot;
            }
            else if (effectData.m_strAlign == "center")
            {
                skill.m_eSkillPos = EmSkillPos.emAlign_RoleChest;
            }
            else if (effectData.m_strAlign == "top")
            {
                skill.m_eSkillPos = EmSkillPos.emAlign_RoleHead;
            }
            skill.m_strNextEffect = effectData.m_strNextEffect;
            PrefabUtility.CreatePrefab("Assets/Resources/Prefabs/effect/skill/" + strSkillName + ".prefab", skillObject);
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "技能预设批量创建完成！", "确定");
    }
    //解析技能配xml置
    static CEffectConfigData ParseSkillData(string url)
    {
        TextAsset xmlAsset = AssetDatabase.LoadAssetAtPath<TextAsset>(url);
        if (xmlAsset == null)
        {
            return null;
        }
        CEffectConfigData effectData = new CEffectConfigData();
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(xmlAsset.text);
        XmlNode xNode = xmlDoc.SelectSingleNode("effect/frame_interval");
        if (xNode != null && xNode.InnerText != "")
        {
            effectData.m_nFrameInterval = int.Parse(xNode.InnerText);
        }
        xNode = xmlDoc.SelectSingleNode("effect/frame_key");
        if (xNode != null && xNode.InnerText != "")
        {
            effectData.m_nFrameKey = int.Parse(xNode.InnerText);
        }
        xNode = xmlDoc.SelectSingleNode("effect/pivotx");
        if (xNode != null && xNode.InnerText != "")
        {
            effectData.m_nPivotx = int.Parse(xNode.InnerText);
        }
        xNode = xmlDoc.SelectSingleNode("effect/pivoty");
        if (xNode != null && xNode.InnerText != "")
        {
            effectData.m_nPivoty = int.Parse(xNode.InnerText);
        }
        xNode = xmlDoc.SelectSingleNode("effect/effect_type");
        if (xNode != null)
        {
            effectData.m_strAlign = xNode.InnerText;
        }
        if (effectData.m_strAlign == "role")
        {
            xNode = xmlDoc.SelectSingleNode("effect/align");
            if (xNode != null)
            {
                effectData.m_strAlign = xNode.InnerText;
            }
        }
        xNode = xmlDoc.SelectSingleNode("effect/play_type");
        if (xNode != null)
        {
            if (xNode.InnerText == "once")
            {
                effectData.m_bLoop = false;
            }
            else
            {
                effectData.m_bLoop = true;
            }
        }
        xNode = xmlDoc.SelectSingleNode("effect/next_effect");
        if (xNode != null)
        {
            effectData.m_strNextEffect = xNode.InnerText;
        }
        return effectData;
    }
    //修改技能图片的Sprite的锚点坐标
    static void CreateSkillAnimationClip(string strSkillName, int nFrameInterval, int nKeyFrame, int nPivotX, int nPivotY, bool bLoop)
    {
        string strSkillPath = "Assets/Textures/effect/skill/" + strSkillName;
        DirectoryInfo dictorys = new DirectoryInfo(strSkillPath);
        //查找此技能的所有帧图片
        FileInfo[] images = dictorys.GetFiles("*.png");
        if (images.Length == 0)
        {
            return;
        }
        // 修改锚点位置
        for (int i = 0; i < images.Length; i++)
        {
            FileInfo fileInfo = images[i];
            //int index = fileInfo.Name.IndexOf("_");
            //string fileName = fileInfo.Name.Substring(0, index);

            Sprite sp = AssetDatabase.LoadAssetAtPath<Sprite>(strSkillPath + "/" + fileInfo.Name);
            float nWidth = sp.texture.width;
            float nHeight = sp.texture.height;
            float nPx = nPivotX / nWidth * 1.0f;
            float nPy = (nHeight - nPivotY) / nHeight * 1.0f;

            TextureImporter texImporter = AssetImporter.GetAtPath(strSkillPath + "/" + fileInfo.Name) as TextureImporter;
            TextureImporterSettings tis = new TextureImporterSettings();
            texImporter.ReadTextureSettings(tis);
            tis.spriteAlignment = (int)SpriteAlignment.Custom;  //设置对齐方式
            tis.spritePivot = new Vector2(nPx, nPy);            //设置sprite的锚点
            tis.mipmapEnabled = false;
            texImporter.SetTextureSettings(tis);                //将这个设置应用到这个Sprite上
            //AssetDatabase.ImportAsset(path + "/" + fileInfo.Name);
            texImporter.SaveAndReimport();
        }

        // 创建技能特效动画
        AnimationClip clip = new AnimationClip();
        EditorCurveBinding curveBinding = new EditorCurveBinding();
        curveBinding.type = typeof(SpriteRenderer);
        curveBinding.path = "";
        curveBinding.propertyName = "m_Sprite";

        ObjectReferenceKeyframe[] keyFrames = new ObjectReferenceKeyframe[images.Length];

        //动画帧率
        clip.frameRate = (int)(1000 / 40 / nFrameInterval);

        //动画长度是按秒为单位
        float frameTime = 1.0f / clip.frameRate;

        for (int i = 0; i < images.Length; i++)
        {
            Sprite sprite = AssetDatabase.LoadAssetAtPath<Sprite>(strSkillPath + "/" + images[i].Name);
            keyFrames[i] = new ObjectReferenceKeyframe();
            keyFrames[i].time = frameTime * i;
            keyFrames[i].value = sprite;
        }
        // 设置关键帧数据
        if (nKeyFrame == 0)
        {
            nKeyFrame = 1;
        }


        List<AnimationEvent> events = new List<AnimationEvent>(2);
        if (nKeyFrame > 0 && nKeyFrame < keyFrames.Length)
        {
            ObjectReferenceKeyframe objRefKey = keyFrames[nKeyFrame - 1];
            AnimationEvent keyEvent = new AnimationEvent();
            keyEvent.time = objRefKey.time;//(float)actData.keyFrame / (float)10;
            keyEvent.functionName = "OnKeyFrameEvent";//函数名，必须该GameObject绑定脚本里包含该函数，否则会报错
            events.Add(keyEvent);
        }

        // 设置结束帧事件
        ObjectReferenceKeyframe objRefEnd = keyFrames[keyFrames.Length - 1];
        AnimationEvent endEvent = new AnimationEvent();
        endEvent.time = objRefEnd.time;//(float)actData.keyFrame / (float)10;
        endEvent.functionName = "OnCompleteEvent";//函数名，必须该GameObject绑定脚本里包含该函数，否则会报错
        events.Add(endEvent);
        AnimationUtility.SetAnimationEvents(clip, events.ToArray());

        AnimationClipSettings clipSettings = AnimationUtility.GetAnimationClipSettings(clip);
        clipSettings.loopTime = bLoop;
        AnimationUtility.SetAnimationClipSettings(clip, clipSettings);

        AnimationUtility.SetObjectReferenceCurve(clip, curveBinding, keyFrames);
        AssetDatabase.CreateAsset(clip, "Assets/Resources/Animation/effect/skill/" + strSkillName + "/skill@" + strSkillName + ".anim");
        AssetDatabase.SaveAssets();
    }

    //[MenuItem("Tools/Prefabs/ModifyNpcTalkPrefabs")]
    //private static void ModifyNpcTalkPrefabs()
    //{
    //    string strNpcAnimFolder = "Assets/Resources/Entity/NPC/";
    //    string[] foderPath = Directory.GetDirectories(strNpcAnimFolder);

    //    DirectoryInfo dictorys = new DirectoryInfo("Assets/Resources/Entity/NPC/");
    //    FileInfo[] arrFiles = dictorys.GetFiles("*.prefab");

    //    List<string> nameList = new List<string>();
    //    for (int i = 0; i < arrFiles.Length; i++)
    //    {
    //        if(arrFiles[i].Name.IndexOf("_battle") == -1)
    //        {
    //            continue;
    //        }
    //        nameList.Add(arrFiles[i].Name);
    //    }
    //    for (int i = 0; i < nameList.Count; i++ )
    //    {
    //        string strName = nameList[i];
    //        string url = "Assets/Resources/Prefabs/Entity/Npc/" + strName + ".prefab";
    //        GameObject prefabObj = AssetDatabase.LoadAssetAtPath(url, typeof(GameObject)) as GameObject;
    //        GameObject tempPrefab = (GameObject)PrefabUtility.InstantiatePrefab(prefabObj);

    //        CBattleRole battleRole = tempPrefab.GetComponent<CBattleRole>();
    //        //AnimationData animationData = ParseAnimationData("Assets/config/" + strName + ".xml");
    //        AnimationData animationData = ParseAnimationData("Assets/config/5001_battle.xml");
    //        battleRole.m_vecLeftTalkPos = animationData.talkData.m_vecLeftTalkPos;
    //        battleRole.m_vecRightTalkPos = animationData.talkData.m_vecRightTalkPos;
    //        battleRole.m_dicTalkData = animationData.talkData.m_dicTalkData;

    //        Transform talkTsm = tempPrefab.transform.FindChild("Canvas/talkGameObj");
    //        if(talkTsm == null)
    //        {
    //            Transform canvasTsm = tempPrefab.transform.FindChild("Canvas");
    //            if(canvasTsm != null)
    //            {
    //                GameObject talkGameObj = new GameObject("talkGameObj");
    //                talkGameObj.transform.SetParent(canvasTsm, false);
    //                talkGameObj.AddComponent<CanvasRenderer>();
    //                RectTransform talkRectTsm = talkGameObj.GetComponent<RectTransform>();
    //                if (talkRectTsm == null)
    //                {
    //                    talkRectTsm = talkGameObj.AddComponent<RectTransform>();
    //                }

    //                talkRectTsm.pivot = new Vector2(0.5f, 0.5f);
    //                talkRectTsm.anchorMin = new Vector2(0.5f, 0.5f);
    //                talkRectTsm.anchorMax = new Vector2(0.5f, 0.5f);
    //            }
    //        }
    //        //对话框位置
    //        talkTsm.localPosition = battleRole.m_vecRightTalkPos;

    //        //刷新对话头像
    //        Transform headIconTsm = talkTsm.FindChild("headIcon");
    //        if(headIconTsm != null)
    //        {
    //            Image headIcon = headIconTsm.gameObject.GetComponent<Image>();
    //            if(headIcon != null)
    //            {
    //                headIcon.sprite = Resources.Load<Sprite>("images/icon/talkBust/" + animationData.talkData.strHeadIconName);
    //            }
    //        }

    //        UnityEngine.Object prefab = PrefabUtility.CreateEmptyPrefab(url);
    //        tempPrefab = PrefabUtility.ReplacePrefab(tempPrefab, prefab);
    //    }

    //    AssetDatabase.SaveAssets();
    //    EditorUtility.ClearProgressBar();
    //    EditorUtility.DisplayDialog("成功", "预设修改完成！", "确定");
    //}
    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/ModifyRideImage")]
    private static void ModifyRideImage()
    {
        string imgFolder = "Resources/images/ride/";
        if (!EditorUtility.DisplayDialog("功能确认", "确定要修改坐骑图集吗？", "确定"))
        {
            return;
        }
        TextAsset xmlAsset = AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/config/rideconfig.xml");
        if (xmlAsset == null)
        {
            return;
        }
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(xmlAsset.text);
        XmlNode xNode = xmlDoc.SelectSingleNode("RideConfig");
        if (xNode == null)
        {
            return;
        }
        int i = 1;
        foreach (XmlNode childNode in xNode.ChildNodes)
        {
            AnimationData animationData = new AnimationData();
            animationData.dicActionData = new Dictionary<string, ActionData>();
            string strID = childNode.Attributes["Id"].Value;
            string strName = childNode.Attributes["Name"].Value;
            foreach (XmlNode oneNode in childNode.ChildNodes)
            {
                ActionData actData = new ActionData();
                actData.nPivotX = int.Parse(oneNode.Attributes["pivotx"].Value);
                actData.nPivotY = int.Parse(oneNode.Attributes["pivoty"].Value);
                animationData.dicActionData.Add(oneNode.Name, actData);
            }
            string urlNormal = Application.dataPath + "/" + imgFolder + strID;
            UpdateProgress(i, xNode.ChildNodes.Count, "修改图集:" + strName);
            UpdateDirectorySpritePivot(animationData, urlNormal);
            i++;
        }
        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "图集修改完成！", "确定");
    }


    [MenuItem("Tools/Prefabs/Modify Texture")]
    private static void ModifyTexture()
    {

        List<string> actionList = new List<string>();
        actionList.Add("riderun");
        actionList.Add("ridestand");
        actionList.Add("run");
        actionList.Add("stand");
        actionList.Add("attack");
        actionList.Add("back");
        actionList.Add("beating");
        actionList.Add("run");
        actionList.Add("skillattack");
        actionList.Add("stand");

        //ModifyEntityTexture("Assets/Prefabs/Entity/Role/", "Role", actionList);
        //ModifyEntityTexture("Assets/Prefabs/Entity/Npc/", "Npc", actionList);
        //ModifySkillTexture();
        ModifyUITexture();
        AssetDatabase.SaveAssets();
    }

    private static void ModifyEntityTexture(string strPath, string type, List<string> actionList)
    {
        string[] arrFiles = Directory.GetFiles(strPath, "*.prefab");

        foreach (string strFile in arrFiles)
        {
            int nStar = strFile.LastIndexOf("/");
            int nEnd = strFile.LastIndexOf(".");
            string strName = strFile.Substring(nStar + 1, nEnd - nStar - 1);
            Debug.Log("file : " + strName);
            if (strName == "6911")
            {
                continue;
            }

            // 加载图集资源
            UnityEngine.Object[] arrAssetObj = AssetDatabase.LoadAllAssetsAtPath("Assets/Textures/" + type.ToLower() + "/" + strName + ".png");
            if (arrAssetObj.Length == 0)
            {
                continue;
            }
            Dictionary<string, Sprite> dicAtlas = new Dictionary<string, Sprite>();
            for (int i = 0; i < arrAssetObj.Length; i++)
            {
                if (arrAssetObj[i].GetType() == typeof(UnityEngine.Sprite))
                {
                    dicAtlas[arrAssetObj[i].name] = arrAssetObj[i] as Sprite;
                }
            }

            // 加载预设文件
            GameObject prefabObj = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Prefabs/Entity/" + type + "/" + strName + ".prefab");
            SpriteRenderer sr = prefabObj.GetComponent<SpriteRenderer>();
            sr.sprite = dicAtlas["stand_01"];


            // 加载动画文件
            foreach (string strAct in actionList)
            {
                AnimationClip clip = AssetDatabase.LoadAssetAtPath<AnimationClip>("Assets/Animation/" + type + "/" + strName + "/" + strName + "@" + strAct + ".anim");
                if (clip == null)
                {
                    continue;
                }
                EditorCurveBinding[] arrEditorBinding = AnimationUtility.GetObjectReferenceCurveBindings(clip);
                if (arrEditorBinding.Length <= 0)
                {
                    continue;
                }
                ObjectReferenceKeyframe[] ArrKeyFrame = AnimationUtility.GetObjectReferenceCurve(clip, arrEditorBinding[0]);
                if (ArrKeyFrame.Length <= 0)
                {
                    continue;
                }

                for (int i = 0; i < ArrKeyFrame.Length; i++)
                {
                    if (ArrKeyFrame[i].value)
                    {
                        ArrKeyFrame[i].value = dicAtlas[ArrKeyFrame[i].value.name];
                    }
                }
                AnimationUtility.SetObjectReferenceCurve(clip, arrEditorBinding[0], ArrKeyFrame);
            }
        }
    }
    private static void ModifySkillTexture()
    {
        string[] arrFiles = Directory.GetFiles("Assets/Prefabs/effect/skill/", "*.prefab");

        foreach (string strFile in arrFiles)
        {
            int nStar = strFile.LastIndexOf("/");
            int nEnd = strFile.LastIndexOf(".");
            string strName = strFile.Substring(nStar + 1, nEnd - nStar - 1);
            Debug.Log("file : " + strName);

            // 加载图集资源
            UnityEngine.Object[] arrAssetObj = AssetDatabase.LoadAllAssetsAtPath("Assets/Textures/effect/skill/" + strName + ".png");
            if (arrAssetObj.Length == 0)
            {
                continue;
            }
            string strFristName = "";
            Dictionary<string, Sprite> dicAtlas = new Dictionary<string, Sprite>();
            for (int i = 0; i < arrAssetObj.Length; i++)
            {
                if (arrAssetObj[i].GetType() == typeof(UnityEngine.Sprite))
                {
                    dicAtlas[arrAssetObj[i].name] = arrAssetObj[i] as Sprite;
                    if (strFristName == "")
                    {
                        strFristName = arrAssetObj[i].name;
                    }
                }
            }

            // 加载预设文件
            GameObject prefabObj = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Prefabs/effect/skill/" + strName + ".prefab");
            SpriteRenderer sr = prefabObj.GetComponent<SpriteRenderer>();
            sr.sprite = dicAtlas[strFristName];

            AnimationClip clip = AssetDatabase.LoadAssetAtPath<AnimationClip>("Assets/Animation/effect/skill/" + strName + "/skill@" + strName + ".anim");
            if (clip == null)
            {
                continue;
            }
            EditorCurveBinding[] arrEditorBinding = AnimationUtility.GetObjectReferenceCurveBindings(clip);
            if (arrEditorBinding.Length <= 0)
            {
                continue;
            }
            ObjectReferenceKeyframe[] ArrKeyFrame = AnimationUtility.GetObjectReferenceCurve(clip, arrEditorBinding[0]);
            if (ArrKeyFrame.Length <= 0)
            {
                continue;
            }

            for (int i = 0; i < ArrKeyFrame.Length; i++)
            {
                if (ArrKeyFrame[i].value)
                {
                    ArrKeyFrame[i].value = dicAtlas[ArrKeyFrame[i].value.name];
                }
            }
            AnimationUtility.SetObjectReferenceCurve(clip, arrEditorBinding[0], ArrKeyFrame);
        }
    }
    private static void ModifyUITexture()
    {
        //GameObject prefabObj = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Prefabs/UI/UICreatRole.prefab");
        //Image uiImage = prefabObj.GetComponent<Image>();
        //if (uiImage != null && uiImage.sprite != null)
        //{
        //    string strPath =  AssetDatabase.GetAssetPath(uiImage.sprite);

        //    Debug.Log(uiImage.sprite.name + " : " + strPath);
        //}
        //for (int i = 0; i < prefabObj.transform.childCount; i++)
        //{
        //    Transform tm = prefabObj.transform.GetChild(i);
        //    uiImage = tm.GetComponent<Image>();
        //    if (uiImage != null && uiImage.sprite != null)
        //    {
        //        string strPath = AssetDatabase.GetAssetPath(uiImage.sprite);

        //        Debug.Log(uiImage.sprite.name + " : " + strPath);
        //    }
        //    //ModifyUIChildTexture(tm.gameObject, dicAtlas, dicComAtlas);
        //}


        // 加载所有界面图集资源
        Dictionary<string, Dictionary<string, Sprite>> dicAtlas = new Dictionary<string, Dictionary<string, Sprite>>();
        string[] arrFiles = Directory.GetFiles("Assets/Textures/ui/", "*.tpsheet", SearchOption.AllDirectories);
        foreach (string strPath in arrFiles)
        {
            string strTpsheetPath = strPath.Replace("\\", "/");
            string assetPath = strTpsheetPath.Substring(0, strTpsheetPath.LastIndexOf(".")) + ".png";

            int nStar = assetPath.LastIndexOf("/");
            int nEnd = assetPath.LastIndexOf(".");
            string strName = assetPath.Substring(nStar + 1, nEnd - nStar - 1);
            //Debug.Log("图集 : " + assetPath + " 名字 : " + strName);

            UnityEngine.Object[] arrAssetObj = AssetDatabase.LoadAllAssetsAtPath(assetPath);
            if (arrAssetObj.Length == 0)
            {
                continue;
            }
            dicAtlas[strName] = new Dictionary<string, Sprite>();
            for (int i = 0; i < arrAssetObj.Length; i++)
            {
                if (arrAssetObj[i].GetType() == typeof(UnityEngine.Sprite))
                {
                    dicAtlas[strName][arrAssetObj[i].name] = arrAssetObj[i] as Sprite;
                }
            }
        }

        string[] arrPreFiles = Directory.GetFiles("Assets/Prefabs/UI/", "*.prefab", SearchOption.AllDirectories);
        foreach (string strPreFile in arrPreFiles)
        {
            if (strPreFile == "Assets/Prefabs/UI/UIBattleTopInfo" || strPreFile == "Assets/Prefabs/UI/UICreatRole")
            {
                continue;
            }

            //Debug.Log("Prefabs file : " + strPreFile);
            GameObject prefabObj = AssetDatabase.LoadAssetAtPath<GameObject>(strPreFile);
            GameObject instance = PrefabUtility.InstantiatePrefab(prefabObj) as GameObject;
            ModifyUIChildTexture(instance, dicAtlas);
            PrefabUtility.ReplacePrefab(instance, prefabObj, ReplacePrefabOptions.ConnectToPrefab);
            UnityEngine.Object.DestroyImmediate(instance);
        }

    }
    private static void ModifyUIChildTexture(GameObject prefabObj, Dictionary<string, Dictionary<string, Sprite>> dicAtlas)
    {
        Image uiImage = prefabObj.GetComponent<Image>();
        if (uiImage != null && uiImage.sprite != null)
        {
            string strPath = AssetDatabase.GetAssetPath(uiImage.sprite);

            int nStar = strPath.LastIndexOf("/");
            int nEnd = strPath.LastIndexOf(".");
            if (nEnd != -1)
            {
                string strSubPath = strPath.Substring(0, nStar);
                string strSheetName = strSubPath.Substring(strSubPath.LastIndexOf("/") + 1);
                string strName = strPath.Substring(nStar + 1, nEnd - nStar - 1);
                //Debug.Log("sheet : " + strSheetName + "  ------- tex : " + strName);
                if (dicAtlas.ContainsKey(strSheetName))
                {
                    if (dicAtlas[strSheetName].ContainsKey(strName))
                    {
                        uiImage.sprite = dicAtlas[strSheetName][strName];
                    }
                    else
                    {
                        Debug.Log("图集(" + strSheetName + ")里无此图片 ：" + strName + " ---- path : " + strPath + " --- prefab : " + prefabObj.name);
                    }
                }
                else
                {
                    Debug.Log("无此图集 ： " + strSheetName + " ---- path : " + strPath + " --- prefab : " + prefabObj.name);
                }
            }

        }
        for (int i = 0; i < prefabObj.transform.childCount; i++)
        {
            Transform tm = prefabObj.transform.GetChild(i);
            ModifyUIChildTexture(tm.gameObject, dicAtlas);
        }
    }
    [MenuItem("Tools/Prefabs/Modify Texture ios format")]
    public static void ModifyTextureIOSFormat()
    {
        string[] arrFiles = Directory.GetFiles("Assets/Textures/", "*.png", SearchOption.AllDirectories);
        int nIndex = 1;
        foreach (string strFile in arrFiles)
        {
            // 判断是否是图集
            string strTpsheetPath = strFile.Substring(0, strFile.LastIndexOf(".")) + ".tpsheet";
            if (!File.Exists(strTpsheetPath))
            {
                continue;
            }
            TextureImporter txImporter = TextureImporter.GetAtPath(strFile) as TextureImporter;
            if (txImporter == null)
            {
                continue;
            }
            Debug.Log(strFile);
            UpdateProgress(nIndex++, arrFiles.Length, "tex : " + strFile);
            txImporter.SetPlatformTextureSettings("iPhone", 2048, TextureImporterFormat.PVRTC_RGBA4, 100, false);
            txImporter.SaveAndReimport();
        }
    }

    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/Update HpBar")]
    private static void DeleteShadow()
    {
        //批量删除NPC的残影
        string prefabFolder = "Prefabs/Entity/NPC/";
        if (!EditorUtility.DisplayDialog("功能确认", "开始执行？", "确定"))
        {
            return;
        }

        List<string> listBattleName = new List<string>();
        DirectoryInfo dictorys = new DirectoryInfo("Assets/" + prefabFolder);
        FileInfo[] arrFiles = dictorys.GetFiles("*.prefab");
        for (int i = 0; i < arrFiles.Length; i++)
        {
            if (arrFiles[i].Name.IndexOf("_battle") == -1)
            {
                continue;
            }
            listBattleName.Add(arrFiles[i].Name);
        }

        //实例化预设，删除残影，保存
        for (int i = 0; i < listBattleName.Count; i++)
        {
            string fileName = listBattleName[i];
            string strPrefabName = fileName.Substring(0, fileName.LastIndexOf(".prefab"));

            GameObject prefabObj = CAssetManager.GetAsset("Prefabs/Entity/NPC/" + strPrefabName + ".prefab") as GameObject;
            GameObject gameObj = GameObject.Instantiate<GameObject>(prefabObj);

            Transform backImgTsm = gameObj.transform.FindChild("Canvas/HPSlider/Background");
            Image backImg = backImgTsm.gameObject.GetComponent<Image>();
            backImg.sprite = CAssetManager.GetAssetSprite("image351", "Textures/ui/com.png");

            Transform fillImgTsm = gameObj.transform.FindChild("Canvas/HPSlider/Fill Area/Fill");
            Image fillImg = fillImgTsm.gameObject.GetComponent<Image>();
            fillImg.sprite = CAssetManager.GetAssetSprite("Textures/ui/comDraw/image126.png");

            PrefabUtility.ReplacePrefab(gameObj, prefabObj);
            UpdateProgress(i, listBattleName.Count, "修改怪物预设:" + fileName);
            AssetDatabase.SaveAssets();
        }

        prefabFolder = "Prefabs/Entity/Role/";
        listBattleName = new List<string>();
        dictorys = new DirectoryInfo("Assets/" + prefabFolder);
        arrFiles = dictorys.GetFiles("*.prefab");
        for (int i = 0; i < arrFiles.Length; i++)
        {
            if (arrFiles[i].Name.IndexOf("_battle") == -1)
            {
                continue;
            }
            listBattleName.Add(arrFiles[i].Name);
        }

        //实例化预设，删除残影，保存
        for (int i = 0; i < listBattleName.Count; i++)
        {
            string fileName = listBattleName[i];
            string strPrefabName = fileName.Substring(0, fileName.LastIndexOf(".prefab"));

            GameObject prefabObj = CAssetManager.GetAsset("Prefabs/Entity/Role/" + strPrefabName + ".prefab") as GameObject;
            GameObject gameObj = GameObject.Instantiate<GameObject>(prefabObj);

            Transform backImgTsm = gameObj.transform.FindChild("Canvas/HPSlider/Background");
            Image backImg = backImgTsm.gameObject.GetComponent<Image>();
            backImg.sprite = CAssetManager.GetAssetSprite("image351", "Textures/ui/com.png");

            Transform fillImgTsm = gameObj.transform.FindChild("Canvas/HPSlider/Fill Area/Fill");
            Image fillImg = fillImgTsm.gameObject.GetComponent<Image>();
            fillImg.sprite = CAssetManager.GetAssetSprite("Textures/ui/comDraw/image126.png");

            PrefabUtility.ReplacePrefab(gameObj, prefabObj);
            UpdateProgress(i, listBattleName.Count, "修改角色预设:" + fileName);
            AssetDatabase.SaveAssets();
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设修改完成！", "确定");
    }

    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/Update NPCLayer")]
    private static void UpdateNpcLayer()
    {
        string prefabFolder = "Prefabs/Entity/NPC/";
        if (!EditorUtility.DisplayDialog("功能确认", "开始执行？", "确定"))
        {
            return;
        }
        List<string> listBattleName = new List<string>();
        DirectoryInfo dictorys = new DirectoryInfo("Assets/" + prefabFolder);
        FileInfo[] arrFiles = dictorys.GetFiles("*.prefab");
        for (int i = 0; i < arrFiles.Length; i++)
        {
            if (arrFiles[i].Name.IndexOf("_battle") >= 0)
            {
                continue;
            }
            listBattleName.Add(arrFiles[i].Name);
        }

        for (int i = 0; i < listBattleName.Count; i++)
        {
            string fileName = listBattleName[i];
            string strPrefabName = fileName.Substring(0, fileName.LastIndexOf(".prefab"));

            GameObject prefabObj = CAssetManager.GetAsset("Prefabs/Entity/NPC/" + strPrefabName + ".prefab") as GameObject;
            GameObject gameObj = GameObject.Instantiate<GameObject>(prefabObj);

            SpriteRenderer spr = gameObj.GetComponent<SpriteRenderer>();
            if (spr != null)
            {
                spr.sortingLayerName = "NpcLayer";
                spr.sortingOrder = 1;
            }
            Transform canvasTsm = gameObj.transform.FindChild("Canvas");
            if (canvasTsm != null)
            {
                Canvas canvas = canvasTsm.gameObject.GetComponent<Canvas>();
                if (canvas != null)
                {
                    canvas.sortingLayerName = "NpcLayer";
                    canvas.sortingOrder = 2;
                }
            }

            Transform shadowTsm = gameObj.transform.FindChild("shadow");
            if (shadowTsm != null)
            {
                spr = shadowTsm.gameObject.GetComponent<SpriteRenderer>();
                if (spr != null)
                {
                    spr.sortingLayerName = "NpcLayer";
                    spr.sortingOrder = 0;
                }
            }

            PrefabUtility.ReplacePrefab(gameObj, prefabObj);
            UpdateProgress(i, listBattleName.Count, "修改怪物预设:" + fileName);
            AssetDatabase.SaveAssets();
        }

        prefabFolder = "Prefabs/Entity/NPC/";
        listBattleName = new List<string>();
        dictorys = new DirectoryInfo("Assets/" + prefabFolder);
        arrFiles = dictorys.GetFiles("*.prefab");
        for (int i = 0; i < arrFiles.Length; i++)
        {
            if (arrFiles[i].Name.IndexOf("_battle") >= 0)
            {
                continue;
            }
            listBattleName.Add(arrFiles[i].Name);
        }

        //实例化预设，删除残影，保存
        for (int i = 0; i < listBattleName.Count; i++)
        {
            string fileName = listBattleName[i];
            string strPrefabName = fileName.Substring(0, fileName.LastIndexOf(".prefab"));

            GameObject prefabObj = CAssetManager.GetAsset("Prefabs/Entity/NPC/" + strPrefabName + ".prefab") as GameObject;
            GameObject gameObj = GameObject.Instantiate<GameObject>(prefabObj);

            PrefabUtility.ReplacePrefab(gameObj, prefabObj);
            UpdateProgress(i, listBattleName.Count, "修改角色预设:" + fileName);
            AssetDatabase.SaveAssets();
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设修改完成！", "确定");
    }

    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/Update NPC Text")]
    private static void UpdateNpcCanvasText()
    {
        string prefabFolder = "Prefabs/Entity/NPC/";
        if (!EditorUtility.DisplayDialog("功能确认", "开始执行？", "确定"))
        {
            return;
        }

        List<string> listBattleName = new List<string>();
        DirectoryInfo dictorys = new DirectoryInfo("Assets/" + prefabFolder);
        FileInfo[] arrFiles = dictorys.GetFiles("*.prefab");
        for (int i = 0; i < arrFiles.Length; i++)
        {
            if (arrFiles[i].Name.IndexOf("_battle") >= 0)
            {
                continue;
            }
            listBattleName.Add(arrFiles[i].Name);
        }

        for (int i = 0; i < listBattleName.Count; i++)
        {
            string fileName = listBattleName[i];
            string strPrefabName = fileName.Substring(0, fileName.LastIndexOf(".prefab"));

            GameObject prefabObj = CAssetManager.GetAsset("Prefabs/Entity/NPC/" + strPrefabName + ".prefab") as GameObject;
            GameObject gameObj = GameObject.Instantiate<GameObject>(prefabObj);

            Transform txtTsm = gameObj.transform.FindChild("Canvas/txtRoleName");
            if (txtTsm != null)
            {
                Text txtNpcName = txtTsm.gameObject.GetComponent<Text>();
                if (txtNpcName != null)
                {
                    //添加描边
                    Outline outline = txtNpcName.gameObject.GetComponent<Outline>();
                    if (outline == null)
                    {
                        outline = txtNpcName.gameObject.AddComponent<Outline>();
                    }
                    outline.effectDistance = new Vector2(1, -1);

                    //字号
                    txtNpcName.fontSize = 16;

                    RectTransform tsm = txtTsm.gameObject.GetComponent<RectTransform>();
                    tsm.sizeDelta = new Vector2(160, tsm.sizeDelta.y);

                    Canvas canvas = gameObj.transform.FindChild("Canvas").gameObject.GetComponent<Canvas>();
                    tsm = canvas.gameObject.GetComponent<RectTransform>();
                    tsm.sizeDelta = new Vector2(160, tsm.sizeDelta.y);
                }
            }

            PrefabUtility.ReplacePrefab(gameObj, prefabObj);
            UpdateProgress(i, listBattleName.Count, "修改怪物预设:" + fileName);
            AssetDatabase.SaveAssets();
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设修改完成！", "确定");
    }

    [ExecuteInEditMode]
    [MenuItem("Tools/Prefabs/UpdateCanvas")]
    private static void MoveRoleObj()
    {
        string prefabFolder = "Prefabs/Entity/Npc/";
        if (!EditorUtility.DisplayDialog("功能确认", "开始执行？", "确定"))
        {
            return;
        }

        List<string> listBattleName = new List<string>();
        DirectoryInfo dictorys = new DirectoryInfo("Assets/" + prefabFolder);
        FileInfo[] arrFiles = dictorys.GetFiles("*.prefab");
        for (int i = 0; i < arrFiles.Length; i++)
        {
            if (arrFiles[i].Name.IndexOf("_battle") >= 0)
            {
                listBattleName.Add(arrFiles[i].Name);
            }
        }

        for (int i = 0; i < listBattleName.Count; i++)
        {
            string fileName = listBattleName[i];
            string strPrefabName = fileName.Substring(0, fileName.LastIndexOf(".prefab"));

            GameObject prefabObj = CAssetManager.GetAsset("Prefabs/Entity/Npc/" + strPrefabName + ".prefab") as GameObject;
            GameObject gameObj = GameObject.Instantiate<GameObject>(prefabObj);

            Transform hpTsm = gameObj.transform.FindChild("Canvas/HPSlider");
            if (hpTsm == null)
            {
                continue;
            }
            RectTransform rt = hpTsm.gameObject.GetComponent<RectTransform>();
            rt.sizeDelta = new Vector2(111, 13);

            Transform backTsm = hpTsm.FindChild("Background");
            if (backTsm != null)
            {
                Image imgBack = backTsm.gameObject.GetComponent<Image>();
                imgBack.sprite = CAssetManager.GetAssetSprite("npc-xuetiaodi", "Textures/ui/com.png");
                imgBack.SetNativeSize();
            }

            Transform FillArea = hpTsm.FindChild("Fill Area");
            if (FillArea != null)
            {
                RectTransform rtm = FillArea.gameObject.GetComponent<RectTransform>();
                rtm.offsetMax = rtm.offsetMin = Vector2.zero;
            }

            Transform FillTsm = hpTsm.FindChild("Fill Area/Fill");
            if (FillTsm != null)
            {
                Image img = FillTsm.gameObject.GetComponent<Image>();
                img.sprite = CAssetManager.GetAssetSprite("Textures/ui/comDraw/bloodBar1.png");
                img.SetNativeSize();
                img.rectTransform.offsetMax = Vector2.zero;
            }

            Transform lineTsm = hpTsm.FindChild("line");
            if (lineTsm == null)
            {
                GameObject obj = new GameObject("line");
                Image img = obj.AddComponent<Image>();
                lineTsm = obj.GetComponent<Transform>();
                lineTsm.SetParent(hpTsm, false);

                img.sprite = CAssetManager.GetAssetSprite("Textures/ui/comDraw/bloodDivideBar.png");
                img.SetNativeSize();
            }

            Transform imgMetierTsm = hpTsm.FindChild("imgMetier");
            if (imgMetierTsm == null)
            {
                GameObject obj = new GameObject("imgMetier");
                Image img = obj.AddComponent<Image>();
                imgMetierTsm = obj.GetComponent<Transform>();
                imgMetierTsm.SetParent(hpTsm, false);

                img.sprite = CAssetManager.GetAssetSprite("iconMetier_1", "Textures/ui/com.png");
                img.SetNativeSize();

                imgMetierTsm.localPosition = new Vector3(-74, 0, 0);
            }

            PrefabUtility.ReplacePrefab(gameObj, prefabObj);
            UpdateProgress(i, listBattleName.Count, "修改怪物预设:" + fileName);
            AssetDatabase.SaveAssets();
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "预设修改完成！", "确定");
    }

}

struct ResName
{
    public string m_strMetierName;
    public string m_strSex;
}

struct AnimationData
{
    public int m_nAttackDistance;   //攻击距离
    public Dictionary<string, ActionData> dicActionData;
    public TalkData talkData;
}

struct ActionData
{
    public int nFrameNum;       //帧数
    public int nFrameInterval;  //帧间隔
    public int keyFrame;//关键帧
    public int nPivotX; //锚点X坐标
    public int nPivotY; //锚点Y坐标
    public float fHeadX;  //头顶X坐标
    public float fHeadY;  //头顶Y坐标
    public float fChestX; //胸部X坐标
    public float fChestY; //胸部Y坐标
}

class CEffectConfigData
{
    public int m_nFrameInterval = 0;
    public int m_nFrameKey = 0;
    public int m_nPivotx = 0;
    public int m_nPivoty = 0;
    public string m_strAlign = "";
    public bool m_bLoop = false;
    public string m_strNextEffect = "";
}

struct TalkData
{
    public Vector2 m_vecLeftTalkPos;        //面朝左侧时，聊天框的位置
    public Vector2 m_vecRightTalkPos;       //面朝右侧时，聊天框的位置
    public string strHeadIconName;
    public Dictionary<int, List<string>> m_dicTalkData;
}