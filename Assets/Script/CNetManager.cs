using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using UnityEngine;



public delegate void OnServerConnect(int nErrCode);
public delegate void OnServerMessage(ByteBuffer msgData);
public delegate void OnServerCloseConnect();

public class CNetManager
{
    private CClientSocket m_clientSocket = new CClientSocket();

    OnServerConnect mOnConnect = null;
    OnServerMessage mServerMessage = null;
    OnServerCloseConnect mCloseConnect = null;

    public CNetManager()
    {

    }
#if UNITY_IPHONE && !UNITY_EDITOR  && USE_CHANNEL_SDK
    [DllImport("__Internal")]
    private static extern string getIPv6(string mHost, string mPort);
#endif
    //"192.168.1.1&&ipv4"
    public static string GetIPv6(string mHost, string mPort)
    {
#if UNITY_IPHONE && !UNITY_EDITOR && USE_CHANNEL_SDK
		string mIPv6 = getIPv6(mHost, mPort);
		return mIPv6;
#else
        return mHost + "&&ipv4";
#endif
    }

    void getIPType(String serverIp, String serverPorts, out String newServerIp, out AddressFamily mIPType)
    {
        mIPType = AddressFamily.InterNetwork;
        newServerIp = serverIp;
        try
        {
            string mIPv6 = GetIPv6(serverIp, serverPorts);
            if (!string.IsNullOrEmpty(mIPv6))
            {
                string[] m_StrTemp = System.Text.RegularExpressions.Regex.Split(mIPv6, "&&");
                if (m_StrTemp != null && m_StrTemp.Length >= 2)
                {
                    string IPType = m_StrTemp[1];
                    if (IPType == "ipv6")
                    {
                        newServerIp = m_StrTemp[0];
                        mIPType = AddressFamily.InterNetworkV6;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.Log("GetIPv6 error:" + e);
        }

    }


    public bool ConnectServer(string strIP, string strPort)
    {
        String newServerIp = "";
        AddressFamily newAddressFamily = AddressFamily.InterNetwork;
        getIPType(strIP, strPort, out newServerIp, out newAddressFamily);
        if (!string.IsNullOrEmpty(newServerIp))
        {
            strIP = newServerIp;
        }
        return m_clientSocket.ConnectServer(strIP, strPort, newAddressFamily);
    }
    public void Run()
    {
        CSocketEvent socketEvent = m_clientSocket.GetSocketEvent();
        if (socketEvent == null)
        {
            return;
        }
        if (socketEvent.eEventType == EmSocketEventType.emSocketEventType_Connect)
        {
            if (mOnConnect != null)
            {
                mOnConnect(socketEvent.byData[0]);
            }
        }
        else if (socketEvent.eEventType == EmSocketEventType.emSocketEventType_Receive)
        {
            if (mServerMessage != null)
            {
                if (socketEvent.byData != null)
                {
                    mServerMessage(new ByteBuffer(socketEvent.byData));
                }
                else
                {
                    mServerMessage(null);
                }

            }
        }
        else if (socketEvent.eEventType == EmSocketEventType.emSocketEventType_Close)
        {
            if (mCloseConnect != null)
            {
                mCloseConnect();
            }
        }
    }

    // 发送消息
    public void Send(ByteBuffer bytes, short nMessageID)
    {
        ByteBuffer temp = new ByteBuffer(bytes.ToBytes());
        byte[] buffer = temp.ReadBytes();
        m_clientSocket.Send(buffer, nMessageID);
    }

    public void SetOnConnectCallback(OnServerConnect connectCallback)
    {
        mOnConnect = connectCallback;
    }

    public void SetCloseConnectCallback(OnServerCloseConnect closeCallback)
    {
        mCloseConnect = closeCallback;
    }

    public void SetServerMessageCallback(OnServerMessage messageCallback)
    {
        mServerMessage = messageCallback;
    }

    public void Destroy()
    {
        m_clientSocket.CloseConnect();
    }
};