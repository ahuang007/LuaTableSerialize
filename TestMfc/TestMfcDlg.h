
// TestMfcDlg.h: 头文件
//

#pragma once

extern "C" {
#include "lua/lua.h"
#include "lua/lauxlib.h"
#include "lua/lualib.h"
}


// CTestMfcDlg 对话框
class CTestMfcDlg : public CDialogEx
{
// 构造
public:
	CTestMfcDlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_TESTMFC_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButton1();
	afx_msg void OnEnChangeEdit3();
	CEdit m_btn_src;
	CEdit m_btn_dst;
	CButton m_btn_format;
	CButton m_btn_serialize;
	afx_msg void OnBnClickedButton2();

	afx_msg void OnClose();

private:
	lua_State* L;
};
