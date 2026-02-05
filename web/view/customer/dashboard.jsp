<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>Customer Dashboard</title>

        <style>
            :root{
                --bg1:#071726;
                --bg2:#0b2a46;
                --text:#f8fafc;
                --muted: rgba(248,250,252,.72);
                --line: rgba(255,255,255,.10);
                --gold:#d8b15b;
            }

            body{
                margin:0;
                font-family: Arial, sans-serif;
                background:#f6f6f6;
            }

            .topbar{
                background: linear-gradient(90deg, var(--bg1), var(--bg2));
                color: var(--text);
                padding:22px 36px;
                display:flex;
                align-items:center;
                gap:18px;
                border-bottom:1px solid var(--line);

                padding-bottom: 110px;
            }

            .dash-avatar{
                width:78px;
                height:78px;
                border-radius:50%;
                background: var(--gold);
                color:#1b1406;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:900;
                font-size:28px;
                border:4px solid rgba(216,177,91,.55);
                box-shadow: 0 10px 24px rgba(0,0,0,.18);
                flex:0 0 auto;
                user-select:none;
            }

            .welcome h1{
                margin:0;
                font-size:34px;
                letter-spacing:.2px;
                color: var(--text);
            }

            .sub{
                margin-top:8px;
                opacity:.9;
                font-size:14px;
                display:flex;
                gap:18px;
                flex-wrap:wrap;
                color: var(--muted);
            }
            .sub span{
                display:flex;
                align-items:center;
                gap:8px;
            }

            .wrap{
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 36px;
            }

            .container{
                display:flex;
                gap:24px;

                /* đè lên topbar */
                margin-top: -78px;

                /* khoảng cách phía dưới */
                padding: 0 0 28px;
            }

            .sidebar{
                width:320px;
                background:#fff;
                border-radius:10px;
                box-shadow: 0 10px 26px rgba(0,0,0,.08);
                overflow:hidden;
                display:flex;
                flex-direction:column;
            }

            /* Sidebar menu */
            .menu{
                padding:14px;
            }

            .menu a{
                display:flex;
                align-items:center;
                gap:12px;
                padding:12px 14px;
                margin:8px 0;
                border-radius:12px;
                text-decoration:none;
                color:#0f172a;
                font-weight:650;
                background:#fff;
                border:1px solid #eef2f7;
                transition:all .18s ease;
                position:relative;
            }
            .menu a .mi{
                width:36px;
                height:36px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f1f5f9;
                color:#0a1b2a;
                font-size:18px;
                flex:0 0 auto;
            }
            .menu a .text{
                display:flex;
                flex-direction:column;
                line-height:1.15;
            }
            .menu a .title{
                font-size:14px;
            }
            .menu a .desc{
                font-size:12px;
                color:#64748b;
                margin-top:3px;
                font-weight:500;
            }

            .menu a:hover{
                background:#f8fafc;
                transform:translateX(2px);
                border-color:#e2e8f0;
            }
            .menu a:hover .mi{
                background:#e9eef6;
            }

            .menu a.active{
                background:#f0ece3;
                border-color:#ead7b3;
                color:#8a5a08;
            }
            .menu a.active .mi{
                background:#fff3db;
                color:#9a6a10;
                box-shadow:0 6px 18px rgba(154,106,16,.12);
            }
            .menu a.active::before{
                content:"";
                position:absolute;
                left:-2px;
                top:10px;
                bottom:10px;
                width:4px;
                border-radius:10px;
                background: rgba(216,177,91,.75);
            }

            /* disabled option */
            .menu a.disabled{
                opacity:.65;
                cursor:not-allowed;
                pointer-events:none;
                background:#fafafa;
                border-color:#f0f0f0;
                transform:none !important;
            }
            .menu a.disabled .mi{
                background:#f3f4f6;
                color:#64748b;
            }
            .menu a.disabled .desc{
                font-style:italic;
            }

            .back{
                margin-top:auto;
                padding:18px;
                background:#fff;
                border-top:1px solid #eee;
            }
            .back a{
                display:flex;
                align-items:center;
                justify-content:center;
                gap:10px;
                background:#0a1b2a;
                color:#fff;
                padding:12px 14px;
                border-radius:8px;
                text-decoration:none;
                font-weight:800;
            }

            .content{
                flex:1;
                background:#fff;
                border-radius:10px;
                box-shadow: 0 10px 26px rgba(0,0,0,.08);
                min-height:420px;
                display:block;
                color:#666;
                padding:22px;
            }


            .empty{
                text-align:center;
            }
            .empty .icon{
                width:56px;
                height:56px;
                margin:0 auto 10px;
                border-radius:50%;
                background:#f0f0f0;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:900;
            }
            .empty h3{
                margin:10px 0 6px;
                color:#111;
            }
            .empty p{
                margin:0;
                color:#888;
                font-style:italic;
            }

            @media (max-width: 900px){
                .topbar{
                    padding:18px;
                    padding-bottom: 90px; /* vẫn chừa chỗ để đè */
                }
                .wrap{
                    padding: 0 18px;
                }
                .container{
                    flex-direction:column;
                    margin-top: -58px; /* mobile đè ít hơn */
                }
                .sidebar{
                    width:100%;
                }
                .welcome h1{
                    font-size:26px;
                }
                .dash-avatar{
                    width:64px;
                    height:64px;
                    font-size:22px;
                }
            }



            /* jspf view profile*/
            /* ===== View Profile (vp-*) ===== */
            .vp-wrap{
                max-width:1100px;
                margin:0 auto;
                width:100%;
                padding:6px 6px 0;
            }
            .vp-h1{
                margin:0 0 16px;
                font-size:28px;
                font-weight:700;
                letter-spacing:-.2px;
                color:#111827;
            }

            .vp-grid{
                display:grid;
                grid-template-columns:340px 1fr;
                gap:20px;
                align-items:start;
            }
            .vp-card{
                background:#fff;
                border:1px solid #e9eef5;
                border-radius:16px;
                box-shadow:0 2px 14px rgba(16,24,40,.06);
            }

            .vp-leftTop{
                padding:18px;
                text-align:center;
            }
            .vp-avatarWrap{
                position:relative;
                display:inline-block;
                margin:4px 0 10px;
            }
            .vp-avatar{
                width:100px;
                height:100px;
                border-radius:50%;
                background:#eef2ff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:34px;
                font-weight:600;
                color:#1f2937;
            }
            .vp-dot{
                position:absolute;
                right:8px;
                bottom:8px;
                width:12px;
                height:12px;
                border-radius:50%;
                background:#22c55e;
                border:3px solid #fff;
            }

            .vp-name{
                margin:6px 0 2px;
                font-size:18px;
                font-weight:700;
            }
            .vp-email{
                margin:0;
                font-size:13px;
                color:#6b7280;
            }
            .vp-roleBadge{
                display:inline-block;
                margin-top:10px;
                padding:6px 14px;
                border-radius:999px;
                background:#eef2ff;
                color:#2563eb;
                font-size:12px;
                font-weight:700;
                letter-spacing:.4px;
                text-transform:uppercase;
            }

            .vp-spacer{
                height:12px;
            }

            .vp-actions{
                padding:16px 18px;
            }
            .vp-actionsTitle{
                margin:0 0 8px;
                font-size:15px;
                font-weight:700;
            }
            .vp-actionItem{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 8px;
                border-radius:10px;
                text-decoration:none;
                color:#111827;
                font-size:14px;
            }
            .vp-actionItem:hover{
                background:#f7f9fd;
            }
            .vp-icon{
                width:26px;
                height:26px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#6b7280;
            }
            .vp-logout{
                color:#dc2626;
            }
            .vp-logout .vp-icon{
                color:#dc2626;
            }

            .vp-sectionHead{
                padding:14px 16px;
                border-bottom:1px solid #e9eef5;
                font-size:15px;
                font-weight:700;
            }
            .vp-sectionBody{
                padding:16px;
            }
            .vp-infoGrid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:14px 24px;
            }

            .vp-label{
                font-size:11px;
                color:#9ca3af;
                letter-spacing:.8px;
                text-transform:uppercase;
                font-weight:600;
                margin-bottom:4px;
            }
            .vp-value{
                font-size:14px;
                font-weight:600;
                line-height:1.35;
                word-break:break-word;
            }

            .vp-statusPill{
                display:inline-block;
                padding:4px 10px;
                border-radius:8px;
                background:#ecfdf3;
                color:#027a48;
                font-weight:700;
                font-size:12px;
            }
            .vp-statusPill.vp-inactive{
                background:#fff1f2;
                color:#b42318;
            }

            @media (max-width: 980px){
                .vp-grid{
                    grid-template-columns:1fr;
                }
                .vp-infoGrid{
                    grid-template-columns:1fr;
                }
            }

            /* ===== View Profile v2 (vp-*) ===== */
            .vp-page{
                width:100%;
                max-width:1100px;
                margin:0 auto;
            }

            .vp-head{
                padding:16px 16px 14px;
                border:1px solid #e9eef5;
                border-radius:16px;
                background:#fff;
                box-shadow:0 2px 14px rgba(16,24,40,.06);
                margin-bottom:16px;
            }

            .vp-id{
                display:flex;
                align-items:center;
                gap:14px;
            }

            .vp-avatarWrap{
                position:relative;
                flex:0 0 auto;
            }
            .vp-avatar{
                width:64px;
                height:64px;
                border-radius:50%;
                background:#eef2ff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:22px;
                font-weight:800;
                color:#1f2937;
            }
            .vp-dot{
                position:absolute;
                right:6px;
                bottom:6px;
                width:10px;
                height:10px;
                border-radius:50%;
                background:#22c55e;
                border:3px solid #fff;
            }

            .vp-title{
                min-width:0;
                flex:1;
            }
            .vp-name{
                font-size:20px;
                font-weight:800;
                color:#111827;
                line-height:1.2;
                margin-bottom:6px;
            }

            .vp-sub{
                display:flex;
                gap:10px;
                flex-wrap:wrap;
                align-items:center;
            }

            .vp-chip{
                display:inline-flex;
                align-items:center;
                gap:8px;
                padding:6px 10px;
                border-radius:999px;
                background:#f8fafc;
                border:1px solid #eef2f7;
                font-size:12px;
            }
            .vp-chipLabel{
                color:#6b7280;
                font-weight:700;
                letter-spacing:.2px;
            }
            .vp-chipValue{
                color:#111827;
                font-weight:800;
            }

            .vp-statusPill{
                display:inline-block;
                padding:4px 10px;
                border-radius:999px;
                background:#ecfdf3;
                color:#027a48;
                font-weight:800;
                font-size:12px;
            }
            .vp-statusPill.vp-inactive{
                background:#fff1f2;
                color:#b42318;
            }

            .vp-emailLine{
                margin-top:10px;
                color:#64748b;
                font-size:13px;
            }

            .vp-grid2{
                display:grid;
                grid-template-columns: 1.25fr .75fr;
                gap:16px;
                align-items:start;
            }

            .vp-card{
                background:#fff;
                border:1px solid #e9eef5;
                border-radius:16px;
                box-shadow:0 2px 14px rgba(16,24,40,.06);
                overflow:hidden;
            }

            .vp-sectionHead{
                padding:12px 14px;
                border-bottom:1px solid #e9eef5;
                font-weight:800;
                color:#111827;
            }

            .vp-sectionBody{
                padding:14px;
            }

            .vp-infoGrid{
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap:12px 16px;
            }

            .vp-field{
                min-width:0;
            }
            .vp-label{
                font-size:11px;
                color:#9ca3af;
                letter-spacing:.8px;
                text-transform:uppercase;
                font-weight:700;
                margin-bottom:4px;
            }
            .vp-value{
                font-size:14px;
                font-weight:700;
                color:#111827;
                word-break:break-word;
                line-height:1.35;
            }

            @media (max-width: 980px){
                .vp-grid2{
                    grid-template-columns: 1fr;
                }
                .vp-infoGrid{
                    grid-template-columns: 1fr;
                }
            }

            /* ===== View Profile (vp2) - pro UI/UX ===== */
            .vp2{
                width:100%;
                max-width:1100px;
                margin:0 auto;
            }

            /* Overview card */
            .vp2-overview{
                background:#fff;
                border:1px solid #e9eef5;
                border-radius:14px;
                box-shadow:0 6px 18px rgba(15,23,42,.06);
                padding:16px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:16px;
                margin-bottom:14px;
            }

            .vp2-left{
                display:flex;
                align-items:center;
                gap:12px;
                min-width:0;
            }

            .vp2-avatar{
                width:56px;
                height:56px;
                border-radius:50%;
                background:#f1f5f9;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:18px;
                font-weight:650;     /* nhấn nhẹ */
                color:#0f172a;
                flex:0 0 auto;
            }

            .vp2-meta{
                min-width:0;
            }
            .vp2-name{
                font-size:18px;
                font-weight:650;     /* không quá đậm */
                color:#0f172a;
                line-height:1.2;
            }

            /* right KPIs */
            .vp2-right{
                display:flex;
                gap:14px;
                align-items:stretch;
                flex:0 0 auto;
            }
            .vp2-kpi{
                padding:10px 12px;
                border:1px solid #eef2f7;
                border-radius:12px;
                background:#f8fafc;
                min-width:160px;
            }
            .vp2-kpiLabel{
                font-size:11px;
                color:#94a3b8;
                text-transform:uppercase;
                letter-spacing:.7px;
                font-weight:600;
                margin-bottom:6px;
            }
            .vp2-kpiValue{
                font-size:14px;
                color:#0f172a;
                font-weight:550;
            }

            /* status pills */
            .vp2-pill{
                display:inline-flex;
                align-items:center;
                padding:6px 10px;
                border-radius:999px;
                background:#ecfdf3;
                color:#027a48;
                font-size:12px;
                font-weight:600;
                border:1px solid rgba(2,122,72,.14);
            }
            .vp2-pill--off{
                background:#fff1f2;
                color:#b42318;
                border-color: rgba(180,35,24,.18);
            }

            /* main card */
            .vp2-card{
                background:#fff;
                border:1px solid #e9eef5;
                border-radius:14px;
                box-shadow:0 6px 18px rgba(15,23,42,.06);
                overflow:hidden;
            }
            .vp2-cardHead{
                padding:12px 14px;
                border-bottom:1px solid #eef2f7;
                font-size:14px;
                font-weight:600;
                color:#0f172a;
            }
            .vp2-fields{
                padding:14px;
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap:12px 18px;
            }
            .vp2-field{
                min-width:0;
            }
            .vp2-span2{
                grid-column: 1 / -1;
            }

            .vp2-label{
                font-size:11px;
                color:#94a3b8;
                letter-spacing:.7px;
                text-transform:uppercase;
                font-weight:600;
                margin-bottom:4px;
            }
            .vp2-value{
                font-size:14px;
                color:#0f172a;
                font-weight:500;     /* tránh đậm */
                line-height:1.45;
                word-break:break-word;
            }
            .vp2-stack{
                display:flex;
                flex-direction:column;
                gap:14px; /* khoảng cách giữa 2 card */
            }


            /* Responsive */
            @media (max-width: 980px){
                .vp2-overview{
                    flex-direction:column;
                    align-items:flex-start;
                }
                .vp2-right{
                    width:100%;
                    flex-direction:column;
                }
                .vp2-kpi{
                    width:100%;
                    min-width:0;
                }
                .vp2-fields{
                    grid-template-columns: 1fr;
                }
                .vp2-span2{
                    grid-column:auto;
                }
            }

            /* ===== Edit Profile (ep) ===== */
            .ep{
                width:100%;
                max-width:1100px;
                margin:0 auto;
            }

            .ep-head{
                background:#fff;
                border:1px solid #e9eef5;
                border-radius:14px;
                box-shadow:0 6px 18px rgba(15,23,42,.06);
                padding:16px 18px;
                margin-bottom:14px;
            }
            .ep-left{
                display:flex;
                align-items:center;
                gap:12px;
            }
            .ep-avatar{
                width:56px;
                height:56px;
                border-radius:50%;
                background:#f1f5f9;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:18px;
                font-weight:600;
                color:#0f172a;
                flex:0 0 auto;
            }
            .ep-title{
                font-size:18px;
                font-weight:600;
                color:#0f172a;
                line-height:1.2;
            }
            .ep-sub{
                margin-top:4px;
                font-size:13px;
                color:#94a3b8;
                font-weight:500;
            }

            /* alerts */
            .ep-alert{
                border-radius:12px;
                padding:10px 12px;
                display:flex;
                gap:10px;
                align-items:flex-start;
                margin-bottom:12px;
                border:1px solid #eef2f7;
                background:#f8fafc;
                color:#334155;
                font-weight:500;
            }
            .ep-alertIcon{
                font-weight:600;
            }
            .ep-alert--error{
                background:#fff1f2;
                border-color:rgba(180,35,24,.18);
                color:#b42318;
            }
            .ep-alert--success{
                background:#ecfdf3;
                border-color:rgba(2,122,72,.14);
                color:#027a48;
            }

            /* card */
            .ep-card{
                background:#fff;
                border:1px solid #e9eef5;
                border-radius:14px;
                box-shadow:0 6px 18px rgba(15,23,42,.06);
                overflow:hidden;
            }
            .ep-cardHead{
                padding:12px 14px;
                border-bottom:1px solid #eef2f7;
                font-size:14px;
                font-weight:600;
                color:#0f172a;
            }
            .ep-body{
                padding:14px;
            }

            .ep-grid{
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap:12px 18px;
            }
            .ep-span2{
                grid-column:1 / -1;
            }

            .ep-field{
                min-width:0;
            }
            .ep-label{
                display:block;
                font-size:11px;
                color:#94a3b8;
                letter-spacing:.7px;
                text-transform:uppercase;
                font-weight:600;
                margin-bottom:6px;
            }
            .ep-input{
                width:100%;
                border:1px solid #e5eaf2;
                background:#fff;
                border-radius:12px;
                padding:10px 12px;
                font-size:14px;
                font-weight:500;
                color:#0f172a;
                outline:none;
                transition:border-color .15s ease, box-shadow .15s ease;
            }
            .ep-input:focus{
                border-color:#cbd5e1;
                box-shadow:0 0 0 4px rgba(148,163,184,.18);
            }
            .ep-input[readonly]{
                background:#f8fafc;
                color:#64748b;
            }
            .ep-textarea{
                resize:vertical;
            }

            .ep-help{
                margin-top:6px;
                font-size:12px;
                color:#94a3b8;
                font-weight:500;
            }

            /* actions */
            .ep-actions{
                margin-top:14px;
                display:flex;
                justify-content:flex-end;
                gap:10px;
            }
            .ep-btn{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                padding:10px 14px;
                border-radius:12px;
                font-size:14px;
                font-weight:600;
                text-decoration:none;
                border:1px solid transparent;
                cursor:pointer;
            }
            .ep-btn--ghost{
                background:#f8fafc;
                color:#0f172a;
                border-color:#e5eaf2;
            }
            .ep-btn--ghost:hover{
                background:#f1f5f9;
            }
            .ep-btn--primary{
                background:#0a1b2a;
                color:#fff;
            }
            .ep-btn--primary:hover{
                filter:brightness(.95);
            }

            /* responsive */
            @media (max-width: 980px){
                .ep-grid{
                    grid-template-columns: 1fr;
                }
                .ep-span2{
                    grid-column:auto;
                }
                .ep-actions{
                    justify-content:stretch;
                }
                .ep-btn{
                    width:100%;
                }
            }

            /* ===== Edit Profile layout fix: equal height, no sticking, no clipped borders ===== */

            /* 1) đảm bảo box sizing chuẩn */
            .ep, .ep * {
                box-sizing: border-box;
            }

            /* 2) card đừng cắt bóng/viền focus */
            .ep-card {
                overflow: visible;
            }

            /* 3) grid: gap rõ ràng */
            .ep-grid{
                display:grid;
                grid-template-columns: 1fr 1fr;
                column-gap:18px;
                row-gap:16px;
                align-items: start;
            }

            /* 4) mỗi field là 1 cột dọc, không bị dính */
            .ep-field{
                display:flex;
                flex-direction:column;
                gap:6px;             /* label-control-help đều nhau */
                min-width:0;
                margin:0;
            }

            /* span 2 cột cho address */
            .ep-span2{
                grid-column: 1 / -1;
            }

            /* 5) label gọn */
            .ep-label{
                margin:0;
                font-size:11px;
                letter-spacing:.6px;
                text-transform:uppercase;
                color:#94a3b8;
                font-weight:500;
            }

            /* 6) CONTROL: cùng height + không bị “cắt viền” */
            .ep-input{
                display:block;
                width:100%;
                height:40px;          /* <<< đồng đều */
                padding:8px 12px;
                border-radius:12px;
                border:1px solid #e5eaf2;
                background:#fff;
                font-size:14px;
                font-weight:500;
                line-height:1.2;
                margin:0;
            }

            /* textarea riêng */
            .ep-textarea{
                height:auto;
                min-height:96px;
                padding:10px 12px;
                line-height:1.4;
            }

            /* 7) help text: CHỪA CHỖ CỐ ĐỊNH để không làm lệch hàng */
            .ep-help{
                margin:0;
                min-height:16px;      /* <<< dù có/không có help thì hàng vẫn đều */
                font-size:12px;
                color:#94a3b8;
                font-weight:500;
            }

            /* 8) focus shadow không bị “cắt viền” */
            .ep-input:focus{
                border-color:#cbd5e1;
                box-shadow:0 0 0 3px rgba(148,163,184,.16);
                outline:none;
            }

            /* 9) readonly nhìn nhẹ */
            .ep-input[readonly]{
                background:#f8fafc;
                color:#64748b;
            }

            /* 10) actions tách rõ */
            .ep-actions{
                margin-top:18px;
                padding-top:14px;
                border-top:1px solid #eef2f7;
                display:flex;
                justify-content:flex-end;
                gap:10px;
            }

            /* mobile */
            @media (max-width: 980px){
                .ep-grid{
                    grid-template-columns: 1fr;
                }
                .ep-span2{
                    grid-column:auto;
                }
                .ep-actions{
                    flex-direction:column;
                }
                .ep-btn{
                    width:100%;
                }
            }






        </style>
    </head>

    <body>

        <div class="topbar">
            <div class="dash-avatar">
                <c:out value="${initials}" default="U"/>
            </div>

            <div class="welcome">
                <h1>Welcome, <c:out value="${profile.fullName}" default="User"/></h1>

                <div class="sub">
                    <span>✉ <c:out value="${profile.email}" default=""/></span>
                    <span>📍 <c:out value="${profile.residenceAddress}" default=""/></span>
                </div>
            </div>
        </div>

        <div class="wrap">
            <div class="container">
                <div class="sidebar">
                    <div class="menu">
                        <a class="${activeTab=='current' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/customer/dashboard?tab=current">
                            <span class="mi">📅</span>
                            <span class="text">
                                <span class="title">Current Bookings</span>
                                <span class="desc">Your upcoming stays</span>
                            </span>
                        </a>

                        <a class="${activeTab=='past' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/customer/dashboard?tab=past">
                            <span class="mi">🏨</span>
                            <span class="text">
                                <span class="title">Past Stays</span>
                                <span class="desc">Stay history</span>
                            </span>
                        </a>

                        <a class="${activeTab=='viewProfile' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/customer/dashboard?tab=viewProfile">
                            <span class="mi">👤</span>
                            <span class="text">
                                <span class="title">View Profile</span>
                                <span class="desc">View your information</span>
                            </span>
                        </a>


                        <a class="${activeTab=='editProfile' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/customer/dashboard?tab=editProfile">
                            <span class="mi">✎</span>
                            <span class="text">
                                <span class="title">Edit Profile</span>
                                <span class="desc">Edit your information</span>
                            </span>
                        </a>

                        <a class="${activeTab=='changePassword' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/customer/dashboard?tab=changePassword">
                            <span class="mi">🔒</span>
                            <span class="text">
                                <span class="title">Change Password</span>
                                <span class="desc">Change your password</span>
                            </span>
                        </a>


                        <a class="actionItem logout" href="${pageContext.request.contextPath}/logout">
                            <span class="mi">⎋</span>
                            <span class="text">
                                <span class="title">Logout</span>
                            </span>
                        </a>
                    </div>

                    <div class="back">
                        <a href="${pageContext.request.contextPath}/">← Back to Home</a>
                    </div>
                </div>

                <div class="content">
                    <jsp:include page="${contentPage}" />
                </div>

            </div>
        </div>
    </body>
</html>
