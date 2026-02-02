<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>Hotel Management System | Home</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <style>
            :root{
                --navy:#071a33;
                --gold:#c8a24a;
                --text:#e9eef6;
                --muted:rgba(233,238,246,.75);
                --shadow:0 18px 50px rgba(0,0,0,.25)
            }
            *{
                box-sizing:border-box
            }
            html,body{
                margin:0;
                font-family:Inter,system-ui;
                background:var(--navy);
                color:var(--text);
                overflow-x:hidden;
            }
            a{
                text-decoration:none;
                color:inherit
            }
            .container{
                width:min(1200px,calc(100% - 48px));
                margin:0 auto
            }
            .section{
                padding:74px 0
            }

            /* Header */
            .header{
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                z-index: 9999;

                background: rgba(7,26,51,.85);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255,255,255,.08);

                transition: background .25s ease, backdrop-filter .25s ease, box-shadow .25s ease;
            }
            .header.is-scrolled{
                background: rgba(7,26,51,.92);
                box-shadow: 0 10px 30px rgba(0,0,0,.18);
            }
            body{
                padding-top: 72px; /* chỉnh đúng chiều cao header của bạn */
            }



            .header-inner{
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:14px 0
            }
            .brand{
                display:flex;
                align-items:center;
                gap:12px
            }
            .logo{
                width:50px;
                height:50px;
                border-radius:50%;
                display:grid;
                place-items:center;
                border:1px solid var(--gold);
                color:var(--gold);
                font-weight:700
            }
            .brand-name{
                font-size:15px;
                letter-spacing:.18em;
                font-weight:700
            }
            .brand-sub{
                font-size:15px;
                opacity:.8
            }
            .nav{
                display:flex;
                gap:22px
            }
            .nav a{
                font-size:15px;
                letter-spacing:.14em;
                opacity:.8
            }
            .nav a.active,.nav a:hover{
                opacity:1
            }

            .btn{
                padding:12px 16px;
                border-radius:10px;
                font-size:12px;
                letter-spacing:.14em;
                font-weight:700;
                border:none;
                cursor:pointer
            }
            .btn-gold{
                background:var(--gold);
                color:#0b1b33
            }
            .btn-navy{
                background:#06152b;
                color:var(--gold);
                border:1px solid rgba(200,162,74,.4)
            }
            .header-actions{
                display:flex;
                align-items:center;
                gap:12px;
            }


            /* ===== HERO (SHARP) ===== */
            /* =========================
               HERO BACKGROUND (CLEAR)
               ========================= */

            .hero{
                position:relative;
                min-height:82vh;
                overflow:hidden;
                padding-bottom: 160px;
            }

            /* Ảnh nền */
            .hero::after{
                content:"";
                position:absolute;
                inset:0;
                background: url("assets/images/home/nen1.jpg") center / cover no-repeat;

                /* làm ảnh rõ hơn */
                filter: contrast(1.08) saturate(1.12) brightness(1.06);

                transform: scale(1.02); /* tránh viền hở */
                z-index:0;
            }

            /* Overlay nhẹ để chữ nổi */
            .hero::before{
                content:"";
                position:absolute;
                inset:0;
                background:
                    radial-gradient(1000px 600px at 50% 35%,
                    rgba(0,0,0,.04),
                    rgba(0,0,0,.22)),
                    linear-gradient(90deg,
                    rgba(7,26,51,.14),
                    rgba(7,26,51,.05),
                    rgba(7,26,51,.14));
                pointer-events:none;
                z-index:1;
            }

            /* =========================
               HERO CONTENT (CENTERED)
               ========================= */

            .hero-content{
                position:relative;
                z-index:2;

                min-height:82vh;
                display:flex;
                flex-direction:column;
                justify-content:center;   /* giữa dọc */
                align-items:center;       /* giữa ngang */

                text-align:center;
                max-width:900px;
                margin:0 auto;
                padding:0 0 120px;        /* chừa chỗ booking bar */

                opacity:1 !important;
                filter:none !important;
            }

            /* vùng tối mềm phía sau chữ (rất quan trọng để dễ đọc) */
            .hero-content::before{
                content:"";
                position:absolute;
                inset:-90px -120px;
                background:
                    radial-gradient(circle at center,
                    rgba(7,26,51,.55),
                    rgba(7,26,51,.18),
                    rgba(7,26,51,0));
                z-index:-1;
                pointer-events:none;
            }

            /* =========================
               HERO TEXT STYLE
               ========================= */

            .hero-eyebrow{
                letter-spacing:.32em;
                font-size:11px;
                font-weight:700;
                color:rgba(255,255,255,.78);
                margin-bottom:14px;
                text-shadow:0 2px 10px rgba(0,0,0,.35);
            }

            .hero-title{
                font-family:"Playfair Display", serif;
                font-size:70px;
                line-height:1.05;
                margin:0;
                color:#fff;
                text-shadow:
                    0 6px 22px rgba(0,0,0,.45),
                    0 1px 2px rgba(0,0,0,.25);
            }

            .hero-subtitle{
                font-family:"Playfair Display", serif;
                font-style:italic;
                color:var(--gold);
                font-size:55px;
                margin-top:10px;
                text-shadow:0 4px 16px rgba(0,0,0,.45);
            }

            .hero-desc{
                margin-top:18px;
                max-width:600px;
                font-size:15px;
                line-height:1.8;
                color:rgba(255,255,255,.92);
                text-shadow:0 2px 12px rgba(0,0,0,.35);
            }

            /* =========================
               CONTENT ABOVE OVERLAY
               ========================= */

            .booking-wrap{
                position:relative;
                z-index:2;
            }

            /* =========================
               RESPONSIVE
               ========================= */

            @media(max-width:768px){
                .hero-title{
                    font-size:42px;
                }
                .hero-subtitle{
                    font-size:32px;
                }
                .hero-desc{
                    font-size:14px;
                }
                .hero-content{
                    padding-bottom:140px;
                }
            }

            /* ✅ BOOKING BAR */
            .booking-wrap{
                position:relative;
                z-index:2;
                margin-top:-72px;
                padding-bottom:50px
            }

            .booking{
                background:rgba(255,255,255,.98);
                color:#0b1b33;
                border-radius:14px;
                padding:18px;
                display:grid;
                grid-template-columns:repeat(4,1fr) auto; /* Check-in, Check-out, Guests, Room Type, Button */
                gap:12px;
                box-shadow:var(--shadow);
                filter:none !important;
                backdrop-filter:none !important;
                opacity:1 !important;
            }

            .field label{
                font-size:11px;
                letter-spacing:.18em;
                font-weight:700;
                color:#555
            }

            .control{
                border:1px solid #ddd;
                border-radius:12px;
                padding:10px 12px;
                margin-top:6px;
                display:flex;
                gap:8px;
                align-items:center;
                background:#fff;
            }
            .control input,.control select{
                border:none;
                outline:none;
                width:100%;
                background:transparent;
                font:inherit;
                color:#0b1b33;
            }

            /* ===== Guests (Adults + Children) gộp chung ===== */
            .guest-field{
                position:relative;
            }
            .guest-trigger{
                width:100%;
                justify-content:space-between;
                cursor:pointer;
                user-select:none;
            }
            .guest-trigger .guest-value{
                color:#0b1b33;
                font-weight:500;
            }
            .guest-trigger .chev{
                width:10px;
                height:10px;
                border-right:2px solid rgba(11,27,51,.55);
                border-bottom:2px solid rgba(11,27,51,.55);
                transform: rotate(45deg);
                margin-left:10px;
                flex:0 0 auto;
            }

            .guest-panel{
                position:absolute;
                top:calc(100% + 10px);
                left:0;
                width:100%;
                min-width:260px;
                background:#fff;
                border:1px solid rgba(11,27,51,.12);
                box-shadow:0 18px 50px rgba(0,0,0,.18);
                border-radius:14px;
                padding:12px;
                z-index:9999; /* đè lên hero */
                display:none;
            }
            .guest-panel.open{
                display:block;
            }

            .guest-row{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:10px;
                margin-bottom:10px;
            }
            .guest-row .mini-label{
                font-size:10px;
                letter-spacing:.24em;
                font-weight:800;
                color:rgba(11,27,51,.55);
                text-transform:uppercase;
                margin-bottom:6px;
                display:block;
            }
            .guest-row .mini-control{
                border:1px solid #e3e6ea;
                border-radius:12px;
                padding:10px 12px;
                display:flex;
                align-items:center;
                background:#fff;
            }
            .guest-row select{
                width:100%;
                border:none;
                outline:none;
                background:transparent;
                font:inherit;
                color:#0b1b33;
            }
            .guest-actions{
                display:flex;
                justify-content:flex-end;
                gap:10px;
                margin-top:6px;
            }
            .guest-btn{
                padding:10px 12px;
                border-radius:12px;
                border:1px solid rgba(11,27,51,.14);
                background:#fff;
                cursor:pointer;
                font-weight:700;
                font-size:12px;
                letter-spacing:.10em;
            }
            .guest-btn.apply{
                background:#06152b;
                color:var(--gold);
                border-color:rgba(200,162,74,.35);
            }

            /* Why choose */
            .why-section{
                min-height: 100vh;           /* vừa đúng 1 màn hình */
                display: flex;
                align-items: center;         /* canh giữa theo chiều dọc */
                padding: 50px 0;
                position: relative;
                z-index: 1;/* giảm padding */
                background: linear-gradient(
                    180deg,
                    #0c2344 0%,
                    #102e55 100%
                    );
            }


            .why-title{
                font-family:"Playfair Display",serif;
                font-size:56px;
                margin:0;
                text-align:center
            }
            .why-quote{
                text-align:center;
                color:rgba(233,238,246,.75);
                font-style:italic;
                max-width:720px;
                margin:14px auto 0;
                line-height:1.8
            }
            .why-divider{
                width:90px;
                height:2px;
                background:rgba(200,162,74,.9);
                margin:22px auto 0;
                border-radius:2px
            }
            .why-grid{
                margin-top:56px;
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:38px
            }
            .why-item{
                text-align:center
            }
            .why-iconbox{
                width:84px;
                height:84px;
                border-radius:18px;
                display:grid;
                place-items:center;
                margin:0 auto 18px;
                background:rgba(255,255,255,.04);
                border:1px solid rgba(255,255,255,.10);
                box-shadow:0 18px 40px rgba(0,0,0,.22)
            }
            .why-icon{
                width:34px;
                height:34px;
                stroke:var(--gold);
                stroke-width:1.6;
                fill:none
            }
            .why-item-title{
                font-family:"Playfair Display",serif;
                font-size:20px;
                margin:0 0 10px
            }
            .why-item-desc{
                margin:0;
                color:rgba(233,238,246,.70);
                line-height:1.9;
                font-size:13px;
                max-width:260px;
                margin-inline:auto
            }

            /* để tạo nền card hover bằng pseudo-element */
            .why-item{
                position: relative;
                padding: 34px 22px;
                border-radius: 18px;
                transition: transform .25s ease, box-shadow .25s ease;
            }

            /* lớp nền card (mặc định ẩn) */
            .why-item::before{
                content:"";
                position:absolute;
                inset:0;
                border-radius: 18px;
                background: rgba(255,255,255,.03);
                border: 1px solid rgba(255,255,255,.06);
                box-shadow: 0 18px 40px rgba(0,0,0,.25);
                opacity: 0;
                transform: translateY(8px);
                transition: opacity .25s ease, transform .25s ease;
                pointer-events:none;
            }

            /* hover: card hiện lên + nhô */
            .why-item:hover{
                transform: translateY(-6px);
            }
            .why-item:hover::before{
                opacity: 1;
                transform: translateY(0);
            }

            /* iconbox: sáng lên + viền vàng */
            .why-item .why-iconbox{
                transition: background .25s ease, border-color .25s ease, transform .25s ease;
            }
            .why-item:hover .why-iconbox{
                background: rgba(200,162,74,.10);
                border-color: rgba(200,162,74,.45);
                transform: translateY(-2px);
            }

            /* title đổi vàng */
            .why-item .why-item-title{
                transition: color .25s ease;
            }
            .why-item:hover .why-item-title{
                color: var(--gold);
            }

            /* desc rõ hơn chút khi hover */
            .why-item .why-item-desc{
                transition: color .25s ease, opacity .25s ease;
            }
            .why-item:hover .why-item-desc{
                color: rgba(233,238,246,.82);
                opacity: 1;
            }


            .room-details{
                padding:18px 18px 20px;
            }
            .room-eyebrow{
                font-size:12px;
                color:rgba(11,27,51,.55);
                font-weight:600;
                margin-bottom:6px;
            }
            .room-title{
                font-family:"Playfair Display",serif;
                font-size:28px;
                margin:0;
            }
            .room-meta{
                margin-top:8px;
                display:flex;
                flex-wrap:wrap;
                align-items:center;
                gap:8px;
                color:rgba(11,27,51,.7);
                font-size:12px;
                font-weight:600;
            }
            .room-meta-dot{
                opacity:.5;
            }
            .room-actions{
                display:flex;
                gap:12px;
                margin-top:16px;
            }

            .room-actions a{
                flex:1;
                height:40px;
                border-radius:4px;
                font-size:11px;
                letter-spacing:.18em;
                font-weight:800;
                text-transform:uppercase;
                display:flex;
                align-items:center;
                justify-content:center;
            }

            /* nút DETAILS: viền xanh navy */
            .btn-outline{
                background:#fff;
                color:#0b1b33;
                border:2px solid #0b1b33;
            }

            /* nút BOOK: nền vàng */
            .btn-gold2{
                background:#c8a24a;
                color:#0b1b33;
                border:2px solid #c8a24a;
            }

            .btn-outline:hover{
                background:#0b1b33;
                color:#fff;
                margin-top: -30px ;
            }

            .btn-gold2:hover{
                filter:brightness(.95);
            }


            .badges{
                margin-top:12px;
                display:flex;
                flex-wrap:wrap;
                gap:8px;
            }
            .badge{
                display:inline-flex;
                align-items:center;
                padding:6px 10px;
                border-radius:8px;
                font-size:12px;
                font-weight:700;
            }
            .badge--primary{
                background:#6f2dbd;
                color:#fff;
            }
            .badge--secondary{
                background:#6f2dbd;
                color:#fff;
                opacity:.85;
            }

            .amenities{
                margin-top:14px;
                display:grid;
                grid-template-columns:repeat(2, minmax(0,1fr));
                gap:10px 14px;
                font-size:12.5px;
                color:rgba(11,27,51,.8);
            }
            .amenity-item{
                display:flex;
                align-items:center;
                gap:8px;
            }
            .amenity-ico{
                width:18px;
                display:inline-flex;
                justify-content:center;
                opacity:.85;
            }

            /* Suites */
            .suites-section{
                background:#fff;
                color:#0b1b33
            }
            .suites-eyebrow{
                text-align:center;
                font-size:11px;
                letter-spacing:.35em;
                color:rgba(11,27,51,.55);
                font-weight:700
            }
            .suites-title{
                text-align:center;
                font-family:"Playfair Display",serif;
                font-size:56px;
                margin:10px 0 0
            }
            .suites-sub{
                text-align:center;
                max-width:760px;
                margin:12px auto 0;
                color:rgba(11,27,51,.55);
                font-style:italic;
                line-height:1.8;
                font-size:14px
            }
            .suites-divider{
                width:84px;
                height:2px;
                background:rgba(200,162,74,.95);
                margin:18px auto 0;
                border-radius:2px
            }
            .suites-grid{
                margin-top:34px;
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:26px
            }
            .suites-card{
                background:#fff;
                border:1px solid rgba(11,27,51,.10);
                border-radius:0;
                overflow:hidden;
                box-shadow:0 10px 30px rgba(0,0,0,.06)
            }
            .suites-media{
                position:relative;
                height:170px;
                background:#f3f5f8
            }
            .suites-media img{
                width:100%;
                height:100%;
                object-fit:cover;
                display:block
            }
            .suites-price{
                position:absolute;
                top:14px;
                right:14px;

                background:#0b1b33;
                color:#fff;

                padding:6px 10px 8px;   /* 🔽 thu nhỏ padding */
                border-radius:6px;

                font-size:10px;         /* 🔽 chữ NIGHTLY nhỏ hơn */
                font-weight:700;
                letter-spacing:.18em;
                text-align:center;

                box-shadow:0 6px 16px rgba(0,0,0,.28);
            }


            .suites-price b{
                display:block;
                margin-top:4px;

                font-size:15px;        /* 🔽 giảm size */
                font-weight:900;
                letter-spacing:.04em;
                color:var(--gold);

                white-space:nowrap;    /* không xuống dòng */
            }
            .suites-price{
                padding:5px 8px 6px;
                font-size:9px;
            }
            .suites-price b{
                font-size:14px;
            }
            .suites-body{
                padding:18px 18px 20px
            }
            .suites-name{
                font-family:"Playfair Display",serif;
                font-size:22px;
                margin:0
            }
            .suites-meta{
                list-style:none;
                padding:0;
                margin:16px 0 0;
                display:flex;
                flex-direction:column;
                gap:12px;
                font-size:11px;
                letter-spacing:.18em;
                text-transform:uppercase;
                color:rgba(11,27,51,.70)
            }
            .suites-meta li{
                display:flex;
                align-items:center;
                gap:10px
            }
            .suites-ico{
                width:18px;
                height:18px;
                display:inline-grid;
                place-items:center;
                flex:0 0 18px
            }
            .suites-ico svg{
                width:18px;
                height:18px;
                stroke:rgba(200,162,74,.95);
                stroke-width:1.8;
                fill:none
            }
            .suites-actions{
                margin-top:18px;
                display:flex;
                gap:12px
            }
            .suites-btn{
                flex:1;
                padding:12px 14px;
                font-size:11px;
                letter-spacing:.16em;
                font-weight:800;
                border-radius:0;
                cursor:pointer;
                text-transform:uppercase;
                display:inline-flex;
                align-items:center;
                justify-content:center
            }
            .suites-btn-detail{
                background:transparent;
                border:1px solid rgba(11,27,51,.85);
                color:rgba(11,27,51,.95)
            }
            .suites-btn-book{
                background:var(--gold);
                border:1px solid rgba(200,162,74,.9);
                color:#0b1b33
            }
            /* Hover/Active cho DETAILS */
            .suites-btn-detail:hover{
                background:#0b1b33;
                color:#fff;
            }

            .suites-btn-detail:active{
                transform: translateY(1px);
            }

            /* Hover cho BOOK (nếu muốn) */
            .suites-btn-book:hover{
                filter: brightness(.95);
            }


            /* Footer */
            .footer-rq{
                padding:64px 0;
                background:
                    radial-gradient(900px 520px at 18% 35%, rgba(200,162,74,.08), transparent 60%),
                    radial-gradient(800px 420px at 85% 0%, rgba(255,255,255,.05), transparent 55%),
                    linear-gradient(180deg, #061a33 0%, #041327 100%);
                border-top: 1px solid rgba(255,255,255,.06);
                color: rgba(233,238,246,.88);
            }
            .footer-rq .rq-wrap{
                display:grid;
                grid-template-columns: 1.15fr .85fr;
                gap:72px;
                align-items:start;
            }
            .rq-brand{
                display:flex;
                align-items:flex-start;
                gap:14px;
            }
            .rq-mark{
                width:46px;
                height:46px;
                border-radius:50%;
                display:grid;
                place-items:center;
                border:1px solid rgba(255,255,255,.14);
                background: rgba(255,255,255,.02);
            }
            .rq-mark svg{
                width:26px;
                height:26px;
                stroke: var(--gold);
                stroke-width:1.6;
                fill:none;
            }
            .rq-brandname{
                margin:0;
                font-size:13px;
                letter-spacing:.22em;
                text-transform:uppercase;
                color:#fff;
                font-weight:800;
                line-height:1.1;
            }
            .rq-brandsub{
                margin-top:4px;
                font-size:10px;
                letter-spacing:.28em;
                text-transform:uppercase;
                color:rgba(233,238,246,.55);
                font-weight:700;
            }
            .rq-desc{
                margin:14px 0 0 60px;
                max-width:520px;
                color:rgba(233,238,246,.55);
                font-size:12.5px;
                line-height:1.85;
            }
            .rq-right-title{
                margin:2px 0 18px 0;
                font-size:10px;
                letter-spacing:.35em;
                text-transform:uppercase;
                color:rgba(200,162,74,.90);
                font-weight:800;
            }
            .rq-info{
                list-style:none;
                padding:0;
                margin:0;
                display:flex;
                flex-direction:column;
                gap:16px;
            }
            .rq-item{
                display:flex;
                gap:12px;
                align-items:flex-start;
                color:rgba(233,238,246,.78);
                font-size:12.5px;
                line-height:1.7;
            }
            .rq-ico{
                width:18px;
                height:18px;
                margin-top:2px;
                flex:0 0 18px;
            }
            .rq-ico svg{
                width:18px;
                height:18px;
                stroke: var(--gold);
                stroke-width:1.8;
                fill:none;
            }
            .rq-link{
                color:rgba(233,238,246,.82);
                text-decoration:none;
            }
            .rq-link:hover{
                color:#fff;
            }

            @media(max-width:1000px){
                .booking{
                    grid-template-columns:1fr 1fr
                }
                .hero-title{
                    font-size:56px
                }
                .hero-subtitle{
                    font-size:44px
                }
                .why-grid{
                    grid-template-columns:repeat(2,1fr)
                }
                .why-title{
                    font-size:46px
                }
                .suites-grid{
                    grid-template-columns:repeat(2,1fr)
                }
                .suites-title{
                    font-size:46px
                }
                .footer-rq .rq-wrap{
                    grid-template-columns:1fr;
                    gap:34px;
                }
                .rq-desc{
                    margin-left:0;
                }
            }
            @media(max-width:600px){
                .booking{
                    grid-template-columns:1fr
                }
                .hero-title{
                    font-size:48px
                }
                .hero-subtitle{
                    font-size:38px
                }
                .why-grid{
                    grid-template-columns:1fr;
                    gap:26px
                }
                .why-title{
                    font-size:40px
                }
                .suites-grid{
                    grid-template-columns:1fr
                }
                .suites-title{
                    font-size:40px
                }
            }
            .suites-card{
                border-radius:12px;
                overflow:hidden;
                box-shadow:0 8px 20px rgba(0,0,0,.06);
            }

            /* Ảnh giữ nguyên như bạn đang có */
            .suites-media{
                height:170px;
            }

            /* Body gọn lại */
            .suites-body{
                padding:14px 16px 16px;     /* giảm padding */
            }

            /* Tên phòng */
            .suites-name{
                font-size:22px;
                line-height:1.15;
                margin:0;
            }

            /* Meta: gọn hơn và chỉ hiển thị 3 dòng */
            .suites-meta{
                margin:12px 0 0;
                gap:10px;
                font-size:11px;
                letter-spacing:.16em;
            }
            .suites-meta li:nth-child(n+4){
                display:none;                /* ✅ chỉ show 3 dòng */
            }

            /* ✅ Ẩn phần badges & amenities (để card nhỏ) */
            .badges,
            .amenities{
                display:none !important;
            }

            /* Buttons gọn hơn */
            .suites-actions{
                margin-top:14px;
                gap:12px;
            }
            .suites-btn{
                padding:10px 12px;
                border-radius:2px;           /* giống hình bạn gửi */
                font-size:11px;
                letter-spacing:.18em;
            }

            /* LOGIN - subtle luxury hover */
            .btn-gold{
                transition:
                    background .18s ease,
                    box-shadow .18s ease,
                    transform .12s ease;
            }

            .btn-gold:hover{
                background:#c19a43; /* vàng đậm rất nhẹ (đẹp hơn #b8933f) */
                box-shadow:0 6px 16px rgba(0,0,0,.15);
            }

            .btn-gold:active{
                transform: translateY(1px);
                box-shadow:0 3px 8px rgba(0,0,0,.18) inset;
            }

            /* LOGIN nền navy (nếu có) */
            .btn-navy{
                transition:
                    background .18s ease,
                    color .18s ease,
                    border-color .18s ease,
                    transform .12s ease;
            }

            .btn-navy:hover{
                background:var(--gold);
                border:1px solid rgba(200,162,74,.9);
                color:#0b1b33;
            }

            .btn-navy:active{
                transform: translateY(1px);
            }

            /* =========================
   ROOM DETAIL MODAL (PRETTY)
   ========================= */
            .room-modal{
                position:fixed;
                inset:0;
                z-index:9999;
                display:none;
                font-family: Inter, system-ui;
            }
            .room-modal.open{
                display:block;
            }

            .room-modal__backdrop{
                position:absolute;
                inset:0;
                background: rgba(7,26,51,.55);
                backdrop-filter: blur(4px);
            }

            .room-modal__panel{
                position:relative;
                width:min(1100px, calc(100% - 64px));
                margin:40px auto;
                background:#fff;
                border-radius:16px;
                overflow:hidden;
                box-shadow:0 18px 60px rgba(0,0,0,.30);
            }

            .room-modal__close{
                position:absolute;
                top:14px;
                right:14px;
                width:38px;
                height:38px;
                border:none;
                border-radius:10px;
                cursor:pointer;
                background:rgba(11,27,51,.06);
                color:#0b1b33;
                font-size:22px;
                line-height:1;
            }
            .room-modal__close:hover{
                background:rgba(11,27,51,.12);
            }

            .room-modal__grid{
                display:grid;
                grid-template-columns: 1.2fr .8fr; /* ảnh | nội dung */
                min-height:540px;
            }

            .room-modal__media{
                background:#f3f5f8;
            }
            .room-modal__media img{
                width:100%;
                height:100%;
                object-fit:cover;
                display:block;
            }

            .room-modal__content{
                padding:42px 46px;
                color:#0b1b33;
            }

            .room-modal__eyebrow{
                font-size:11px;
                letter-spacing:.35em;
                text-transform:uppercase;
                color:rgba(11,27,51,.55);
                font-weight:800;
                margin-bottom:14px;
            }

            .room-modal__title{
                font-family:"Playfair Display", serif;
                font-size:42px;
                margin:0 0 12px 0;
                line-height:1.1;
            }

            .room-modal__desc{
                margin:0;
                color:rgba(11,27,51,.72);
                line-height:1.85;
                font-size:14px;
                max-width:42ch;
            }

            .room-modal__facts{
                margin-top:26px;
                padding-top:18px;
                border-top:1px solid rgba(11,27,51,.10);
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap:18px 26px;
            }

            .room-modal__facts b{
                display:block;
                font-size:10px;
                letter-spacing:.28em;
                text-transform:uppercase;
                color:rgba(11,27,51,.50);
                font-weight:900;
                margin-bottom:6px;
            }

            .room-modal__facts div div{
                font-size:14px;
                font-weight:700;
                color:#0b1b33;
                line-height:1.25;
            }

            .room-modal__actions{
                margin-top:26px;
                display:flex;
                gap:12px;
            }

            .room-modal__btn{
                flex:1;
                height:46px;
                border-radius:12px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:11px;
                letter-spacing:.18em;
                font-weight:900;
                text-transform:uppercase;
                text-decoration:none;
                transition: .18s ease;
            }

            .room-modal__btn-primary{
                background:#0b1b33;
                color:#fff;
                border:1px solid #0b1b33;
            }
            .room-modal__btn-primary:hover{
                transform: translateY(-1px);
                filter:brightness(1.05);
            }

            .room-modal__btn-outline{
                background:#fff;
                color:#0b1b33;
                border:2px solid rgba(11,27,51,.85);
            }
            .room-modal__btn-outline:hover{
                background:#0b1b33;
                color:#fff;
            }

            /* Responsive */
            @media(max-width:900px){
                .room-modal__panel{
                    width:min(980px, calc(100% - 28px));
                    margin:18px auto;
                }
                .room-modal__grid{
                    grid-template-columns:1fr;
                }
                .room-modal__media{
                    height:260px;
                }
                .room-modal__content{
                    padding:28px 22px;
                }
                .room-modal__title{
                    font-size:34px;
                }
            }
            .room-modal__amenities{
                margin-top:18px;
                padding-top:16px;
                border-top:1px solid rgba(11,27,51,.10);
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap:10px 18px;
            }

            .room-modal__amenity{
                display:flex;
                align-items:center;
                gap:10px;
                font-size:13px;
                font-weight:600;
                color:rgba(11,27,51,.80);
            }

            .room-modal__amenity .ico{
                width:18px;
                display:inline-flex;
                justify-content:center;
                opacity:.9;
            }

            /* guest trigger giống input/select */
            .guest-trigger{
                display:flex;
                align-items:center;
                justify-content:space-between;
                height:43px;
                padding:0 10px;
                border:1px solid rgba(11,27,51,.14);
                border-radius:14px;
                background:#fff;
                cursor:pointer;
            }

            .guest-trigger .guest-value{
                font-weight:600;
                color:#0b1b33;
            }

            .guest-trigger .chev{
                width:10px;
                height:10px;
                border-right:2px solid rgba(11,27,51,.55);
                border-bottom:2px solid rgba(11,27,51,.55);
                transform: rotate(45deg);
                margin-left:10px;
            }

            /* panel */
            .guest-panel{
                position:absolute;
                top: calc(100% + 10px);
                left:0;
                width: 60px;
                background:#fff;
                border:1px solid rgba(11,27,51,.12);
                border-radius:16px;
                box-shadow: 0 18px 45px rgba(7,26,51,.18);
                padding:10px 10px 8px;
                display:none;
                z-index:50;
            }

            .guest-panel.open{
                display:block;
            }

            /* row */
            .guest-row{
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap:14px;
            }

            .mini-label{
                display:block;
                font-size:11px;
                letter-spacing:.22em;
                text-transform:uppercase;
                color:rgba(11,27,51,.65);
                margin-bottom:8px;
            }

            /* stepper */
            .stepper{
                height:44px;
                border:1px solid rgba(11,27,51,.14);
                border-radius:14px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:0 10px;
                background:#fff;
            }

            .step-btn{
                width:34px;
                height:34px;
                border-radius:10px;
                border:1px solid rgba(11,27,51,.14);
                background:#fff;
                color:#0b1b33;
                font-size:18px;
                line-height:1;
                cursor:pointer;
                transition: transform .15s ease, border-color .15s ease;
            }

            .step-btn:hover{
                transform: translateY(-1px);
                border-color: rgba(11,27,51,.28);
            }

            .step-btn:disabled{
                opacity:.45;
                cursor:not-allowed;
                transform:none;
            }

            .step-value{
                font-weight:700;
                color:#0b1b33;
                min-width:24px;
                text-align:center;
            }

            /* actions */
            .guest-actions{
                display:flex;
                justify-content:flex-end;
                margin-top:12px;
            }

            .guest-btn{
                height:44px;
                padding:0 18px;
                border-radius:14px;
                border:1px solid rgba(11,27,51,.14);
                background:#fff;
                font-weight:700;
                cursor:pointer;
            }

            .guest-btn.apply{
                background: var(--gold);
                border-color: rgba(200,162,74,.9);
                color:#0b1b33;
            }

            .booking-wrap {
                position: relative;
                z-index: 50; /* cao hơn section bên dưới */
            }

            .guest-field {
                position: relative;
                z-index: 80;
            }

            .guest-panel {
                position: absolute;
                z-index: 100;
            }
            .btn-find{
                padding: 10px 18px;     /* thấp hơn */
                height: 48px;           /* ép chiều cao */
                border-radius: 12px;
                font-size: 11px;
                letter-spacing: .18em;
                font-weight: 800;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-top: 20px;
            }


        </style>
    </head>

    <body>
        <c:set var="defaultImg" value="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1600&q=80&auto=format&fit=crop"/>

        <header class="header">
            <div class="container header-inner">
                <div class="brand">
                    <div class="logo">HMS</div>
                    <div>
                        <div class="brand-name">
                            <c:out value="${hotel != null ? hotel.name : 'HOTEL MANAGEMENT SYSTEM'}"/>
                        </div>
                        <div class="brand-sub">HOME</div>
                    </div>
                </div>

                <nav class="nav">
                    <a class="active" href="${pageContext.request.contextPath}/home">Home</a>

                    <a href="#rooms">Rooms</a>
                    <a href="#contact">Contact</a>
                </nav>

                <!--  <div class="header-actions">-->
                    <!--  <a class="btn btn-navy" href="${pageContext.request.contextPath}/login">LOGIN</a>-->

                <!--  <button class="btn btn-gold" type="button">BOOK NOW</button>-->
                <!--  </div>-->
                <div class="header-actions">

                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <a class="btn btn-navy"
                               href="${pageContext.request.contextPath}/login">
                                LOGIN
                            </a>
                        </c:when>

                        <c:otherwise>
                            <a class="btn btn-navy"
                               href="${pageContext.request.contextPath}/logout">
                                LOGOUT
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <button class="btn btn-gold" type="button">
                        BOOK NOW
                    </button>

                </div>


            </div>
        </header>

        <section class="hero">
            <div class="container hero-content">
                <div class="hero-eyebrow">WELCOME TO EXCELLENCE</div>
                <h1 class="hero-title">Majestic Comfort</h1>
                <div class="hero-subtitle">Redefined</div>
                <p class="hero-desc">Discover premium room types managed seamlessly by your Hotel Management System.</p>
            </div>

            <div class="container booking-wrap">
                <!-- NOTE: nếu bạn có action thật thì thay action/method -->
                <form class="booking" action="#" method="get">
                    <div class="field">
                        <label>Check-in</label>
                        <div class="control">
                            <input type="date" name="checkIn" value="${defaultCheckIn}">
                        </div>
                    </div>

                    <div class="field">
                        <label>Check-out</label>
                        <div class="control">
                            <input type="date" name="checkOut" value="${defaultCheckOut}">
                        </div>
                    </div>

                    <!-- ✅ GUESTS gộp chung: Adults + Children -->
                    <div class="field guest-field" id="guestField">
                        <label>Guests</label>

                        <!-- Trigger -->
                        <div class="control guest-trigger" id="guestTrigger" role="button" tabindex="0"
                             aria-haspopup="dialog" aria-expanded="false">
                            <span class="guest-value" id="guestValue">2 Adults, 0 Children</span>
                            <span class="chev" aria-hidden="true"></span>
                        </div>

                        <!-- Hidden inputs để submit -->
                        <input type="hidden" name="adults" id="adultsHidden" value="2">
                        <input type="hidden" name="children" id="childrenHidden" value="0">

                        <!-- Panel -->
                        <div class="guest-panel" id="guestPanel" role="dialog" aria-label="Select guests">
                            <div class="guest-row">
                                <!-- Adults -->
                                <div class="guest-stepper">
                                    <span class="mini-label">Adults</span>
                                    <div class="stepper">
                                        <button type="button" class="step-btn" data-step="adults" data-dir="-1" aria-label="Decrease adults">−</button>
                                        <span class="step-value" id="adultsValue">2</span>
                                        <button type="button" class="step-btn" data-step="adults" data-dir="1" aria-label="Increase adults">+</button>
                                    </div>
                                </div>

                                <!-- Children -->
                                <div class="guest-stepper">
                                    <span class="mini-label">Children</span>
                                    <div class="stepper">
                                        <button type="button" class="step-btn" data-step="children" data-dir="-1" aria-label="Decrease children">−</button>
                                        <span class="step-value" id="childrenValue">0</span>
                                        <button type="button" class="step-btn" data-step="children" data-dir="1" aria-label="Increase children">+</button>
                                    </div>
                                </div>
                            </div>

                            <!-- chỉ cần Apply thôi -->
                            <div class="guest-actions">
                                <button type="button" class="guest-btn apply" id="guestApply">Apply</button>
                            </div>
                        </div>
                    </div>

                    <div class="field">
                        <label>Room Type</label>
                        <div class="control">
                            <select name="roomTypeId">
                                <option value="">Any</option>
                                <c:forEach var="rt" items="${roomTypes}">
                                    <option value="${rt.roomTypeId}">
                                        <c:out value="${rt.name}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <button class="btn btn-navy btn-find" type="submit" >FIND ROOMS</button>
                </form>
            </div>
        </section>

        <section class="section why-section" id="why">
            <div class="container">
                <h2 class="why-title">Why choose our hotel?</h2>
                <p class="why-quote">
                    “We provide more than just a place to sleep. We provide an experience.”
                </p>
                <div class="why-divider"></div>

                <div class="why-grid">
                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M12 2v4"/><path d="M12 18v4"/>
                            <path d="M4.93 4.93l2.83 2.83"/><path d="M16.24 16.24l2.83 2.83"/>
                            <path d="M2 12h4"/><path d="M18 12h4"/>
                            <path d="M4.93 19.07l2.83-2.83"/><path d="M16.24 7.76l2.83-2.83"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Easy Online Booking</h3>
                        <p class="why-item-desc">
                            Secure your room in just a few clicks with our streamlined checkout.
                        </p>
                    </div>

                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M12 2l7 4v6c0 5-3 9-7 10C8 21 5 17 5 12V6l7-4z"/>
                            <path d="M9 12l2 2 4-4"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Secure Payment</h3>
                        <p class="why-item-desc">
                            Your data is protected with industry-standard encryption protocols.
                        </p>
                    </div>

                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M3 12V8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v4"/>
                            <path d="M2 18h20"/><path d="M4 18v-3"/><path d="M20 18v-3"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Comfortable Rooms</h3>
                        <p class="why-item-desc">
                            Premium linens, quiet environments, and world-class amenities.
                        </p>
                    </div>

                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M4 20h16"/>
                            <path d="M12 4c3 0 5 2 5 5v3H7V9c0-3 2-5 5-5z"/>
                            <path d="M7 12v3a5 5 0 0 0 10 0v-3"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Friendly Service</h3>
                        <p class="why-item-desc">
                            Our 24/7 concierge is dedicated to making your stay perfect.
                        </p>
                    </div>
                </div>
            </div>
        </section>


        <section class="section suites-section" id="rooms">
            <div class="container">
                <div class="suites-eyebrow">SANCTUARY OF PEACE</div>
                <h2 class="suites-title">Our Signature Suites</h2>
                <p class="suites-sub">“Experience the convergence of heritage and modern luxury in our meticulously curated spaces.”</p>
                <div class="suites-divider"></div>

                <div class="suites-grid">
                    <c:forEach var="rt" items="${roomTypes}" varStatus="st">
                        <c:if test="${st.index < 8}">

                            <%-- 1) Lấy url ảnh từ DB --%>
                            <c:set var="rawImg" value="${empty rt.imageUrl ? '' : rt.imageUrl}" />

                            <%-- 2) Nếu ảnh trong DB là URL ngoài (http/https) thì dùng luôn
                                   Nếu là path nội bộ (/assets... hoặc assets...) thì cộng contextPath
                                   Nếu rỗng thì dùng defaultImg --%>
                            <c:choose>
                                <c:when test="${empty rawImg}">
                                    <c:set var="img" value="${defaultImg}" />
                                </c:when>

                                <c:when test="${fn:startsWith(rawImg, 'http://') or fn:startsWith(rawImg, 'https://')}">
                                    <c:set var="img" value="${rawImg}" />
                                </c:when>

                                <c:when test="${fn:startsWith(rawImg, '/')}">
                                    <c:set var="img" value="${pageContext.request.contextPath}${rawImg}" />
                                </c:when>

                                <c:otherwise>
                                    <c:set var="img" value="${pageContext.request.contextPath}/${rawImg}" />
                                </c:otherwise>
                            </c:choose>

                            <%-- tách description: "Bed • View • Size" --%>
                            <c:set var="desc" value="${empty rt.description ? '' : rt.description}" />
                            <c:set var="parts" value="${fn:split(desc, '•')}" />

                            <c:set var="bedText"  value="${fn:length(parts) > 0 ? fn:trim(parts[0]) : ''}" />
                            <c:set var="viewText" value="${fn:length(parts) > 1 ? fn:trim(parts[1]) : ''}" />
                            <c:set var="sizeText" value="${fn:length(parts) > 2 ? fn:trim(parts[2]) : ''}" />

                            <div class="suites-card">
                                <div class="suites-media">
                                    <img src="${img}" alt="<c:out value='${rt.name}'/>"
                                         onerror="this.onerror=null;this.src='${defaultImg}';">

                                    <div class="suites-price">
                                        NIGHTLY
                                        <b>
                                            <c:choose>
                                                <c:when test="${rt.priceToday != null}">
                                                    $<c:out value="${rt.priceToday}"/>
                                                </c:when>
                                                <c:otherwise>CONTACT</c:otherwise>
                                            </c:choose>
                                        </b>
                                    </div>
                                </div>

                                <div class="room-details">
                                    <div class="room-eyebrow">Room photos and details</div>
                                    <h3 class="room-title"><c:out value="${rt.name}"/></h3>

                                    <ul class="suites-meta" style="margin-top:14px;">
                                        <li>
                                            <span class="suites-ico" aria-hidden="true">
                                                <svg viewBox="0 0 24 24">
                                                <path d="M3 12V8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v4"/>
                                                <path d="M2 18h20"/><path d="M4 18v-3"/><path d="M20 18v-3"/>
                                                </svg>
                                            </span>
                                            <span><c:out value="${not empty bedText ? bedText : 'Bed info'}"/></span>
                                        </li>

                                        <li>
                                            <span class="suites-ico" aria-hidden="true">
                                                <svg viewBox="0 0 24 24">
                                                <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/>
                                                <path d="M12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/>
                                                </svg>
                                            </span>
                                            <span><c:out value="${not empty viewText ? viewText : 'View'}"/></span>
                                        </li>

                                        <li>
                                            <span class="suites-ico" aria-hidden="true">
                                                <svg viewBox="0 0 24 24">
                                                <path d="M8 3H3v5"/><path d="M16 3h5v5"/>
                                                <path d="M8 21H3v-5"/><path d="M16 21h5v-5"/>
                                                <path d="M3 8l6-6"/><path d="M21 8l-6-6"/>
                                                <path d="M3 16l6 6"/><path d="M21 16l-6 6"/>
                                                </svg>
                                            </span>
                                            <span><c:out value="${not empty sizeText ? sizeText : 'N/A'}"/></span>
                                        </li>
                                    </ul>

                                    <div class="suites-actions" style="padding:0 18px 18px; margin-top:14px;">
                                        <a class="suites-btn suites-btn-detail js-room-detail"
                                           href="javascript:void(0)"
                                           data-id="${rt.roomTypeId}"
                                           data-name="${fn:escapeXml(rt.name)}"
                                           data-img="${img}"
                                           data-price="${rt.priceToday}"
                                           data-bed="${fn:escapeXml(bedText)}"
                                           data-view="${fn:escapeXml(viewText)}"
                                           data-size="${fn:escapeXml(sizeText)}"
                                           data-adult="${rt.maxAdult}"
                                           data-child="${rt.maxChildren}"
                                           data-desc="${fn:escapeXml(rt.description)}"
                                           data-amenities="Private bathroom|Shower|Hair dryer|Toiletries|Wi-Fi (free)|Satellite/cable channels|Air conditioning">
                                            DETAILS
                                        </a>

                                        <a class="suites-btn suites-btn-book"
                                           href="${pageContext.request.contextPath}/booking?roomTypeId=${rt.roomTypeId}">
                                            BOOK
                                        </a>
                                    </div>
                                </div>
                            </div>

                        </c:if>
                    </c:forEach>
                </div>

            </div>
        </section>




        <footer class="footer-rq" id="contact">
            <div class="container rq-wrap">
                <div>
                    <div class="rq-brand">
                        <div class="rq-mark" aria-hidden="true">
                            <svg viewBox="0 0 24 24">
                            <path d="M3 9l4 4 5-7 5 7 4-4"/>
                            <path d="M5 20h14"/>
                            <path d="M6 18h12"/>
                            <path d="M6 18l-1-7h14l-1 7"/>
                            </svg>
                        </div>
                        <div>
                            <h3 class="rq-brandname"><c:out value="${hotel != null ? hotel.name : 'Regal Quintet Hotel'}"/></h3>
                            <div class="rq-brandsub">Hotel & Resorts</div>
                        </div>
                    </div>

                    <p class="rq-desc"><c:out value="${hotel != null ? hotel.content : 'A refined stay with modern comfort and timeless elegance.'}"/></p>
                </div>

                <div>
                    <div class="rq-right-title">Reservations & Location</div>

                    <ul class="rq-info">
                        <li class="rq-item">
                            <span class="rq-ico" aria-hidden="true">
                                <svg viewBox="0 0 24 24">
                                <path d="M12 21s7-4.5 7-11a7 7 0 1 0-14 0c0 6.5 7 11 7 11z"/>
                                <path d="M12 10.5a2.2 2.2 0 1 0 0-4.4 2.2 2.2 0 0 0 0 4.4z"/>
                                </svg>
                            </span>
                            <span><c:out value="${hotel != null ? hotel.address : '—'}"/></span>
                        </li>

                        <li class="rq-item">
                            <span class="rq-ico" aria-hidden="true">
                                <svg viewBox="0 0 24 24">
                                <path d="M22 16.9v3a2 2 0 0 1-2.2 2c-9.6-.9-17.1-8.4-18-18A2 2 0 0 1 3.9 1h3a2 2 0 0 1 2 1.7c.1 1 .3 2 .6 3a2 2 0 0 1-.5 2.1L8 9a16 16 0 0 0 7 7l1.2-1a2 2 0 0 1 2.1-.5c1 .3 2 .5 3 .6a2 2 0 0 1 1.7 2z"/>
                                </svg>
                            </span>
                            <a class="rq-link" href="tel:${hotel != null ? hotel.phone : ''}">
                                <c:out value="${hotel != null ? hotel.phone : '—'}"/>
                            </a>
                        </li>

                        <li class="rq-item">
                            <span class="rq-ico" aria-hidden="true">
                                <svg viewBox="0 0 24 24">
                                <path d="M4 4h16v16H4z"/>
                                <path d="M4 6l8 7 8-7"/>
                                </svg>
                            </span>
                            <a class="rq-link" href="mailto:${hotel != null ? hotel.email : ''}">
                                <c:out value="${hotel != null ? hotel.email : '—'}"/>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </footer>

        <script>
            (function () {
                const field = document.getElementById('guestField');
                const trigger = document.getElementById('guestTrigger');
                const panel = document.getElementById('guestPanel');

                const valueEl = document.getElementById('guestValue');

                const adultsHidden = document.getElementById('adultsHidden');
                const childrenHidden = document.getElementById('childrenHidden');

                const adultsValueEl = document.getElementById('adultsValue');
                const childrenValueEl = document.getElementById('childrenValue');

                const btnApply = document.getElementById('guestApply');

                const LIMITS = {
                    adults: {min: 1, max: 6},
                    children: {min: 0, max: 4}
                };

                function openPanel() {
                    panel.classList.add('open');
                    trigger.setAttribute('aria-expanded', 'true');
                }
                function closePanel() {
                    panel.classList.remove('open');
                    trigger.setAttribute('aria-expanded', 'false');
                }

                function formatText(a, c) {
                    const aText = a + ' Adult' + (a > 1 ? 's' : '');
                    const cText = c + ' Child' + (c === 1 ? '' : 'ren');
                    return aText + ', ' + cText;
                }

                function setStepperUI(a, c) {
                    adultsValueEl.textContent = String(a);
                    childrenValueEl.textContent = String(c);

                    // disable min/max
                    document.querySelectorAll('.step-btn[data-step="adults"][data-dir="-1"]').forEach(b => b.disabled = (a <= LIMITS.adults.min));
                    document.querySelectorAll('.step-btn[data-step="adults"][data-dir="1"]').forEach(b => b.disabled = (a >= LIMITS.adults.max));
                    document.querySelectorAll('.step-btn[data-step="children"][data-dir="-1"]').forEach(b => b.disabled = (c <= LIMITS.children.min));
                    document.querySelectorAll('.step-btn[data-step="children"][data-dir="1"]').forEach(b => b.disabled = (c >= LIMITS.children.max));
                }

                function syncFromHidden() {
                    const a = parseInt(adultsHidden.value || '2', 10);
                    const c = parseInt(childrenHidden.value || '0', 10);
                    valueEl.textContent = formatText(a, c);
                    setStepperUI(a, c);
                }

                // init
                syncFromHidden();

                trigger.addEventListener('click', function () {
                    panel.classList.contains('open') ? closePanel() : openPanel();
                });

                trigger.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        panel.classList.contains('open') ? closePanel() : openPanel();
                    }
                    if (e.key === 'Escape')
                        closePanel();
                });

                // step buttons
                panel.addEventListener('click', function (e) {
                    const btn = e.target.closest('.step-btn');
                    if (!btn)
                        return;

                    const step = btn.dataset.step;        // adults/children
                    const dir = parseInt(btn.dataset.dir, 10); // -1/+1

                    let a = parseInt(adultsValueEl.textContent || '2', 10);
                    let c = parseInt(childrenValueEl.textContent || '0', 10);

                    if (step === 'adults') {
                        a = Math.min(LIMITS.adults.max, Math.max(LIMITS.adults.min, a + dir));
                    } else {
                        c = Math.min(LIMITS.children.max, Math.max(LIMITS.children.min, c + dir));
                    }

                    setStepperUI(a, c);
                });

                btnApply.addEventListener('click', function () {
                    const a = parseInt(adultsValueEl.textContent || '2', 10);
                    const c = parseInt(childrenValueEl.textContent || '0', 10);

                    adultsHidden.value = String(a);
                    childrenHidden.value = String(c);
                    valueEl.textContent = formatText(a, c);
                    closePanel();
                });

                // click outside to close
                document.addEventListener('click', function (e) {
                    if (!field.contains(e.target))
                        closePanel();
                });

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape')
                        closePanel();
                });
            })();
        </script>

        <!-- ROOM DETAIL MODAL -->
        <div class="room-modal" id="roomModal" aria-hidden="true">
            <div class="room-modal__backdrop" data-close="1"></div>

            <div class="room-modal__panel">
                <button class="room-modal__close" type="button" data-close="1">×</button>

                <div class="room-modal__grid">
                    <div class="room-modal__media">
                        <img id="rmImg" src="" alt="">
                    </div>

                    <div class="room-modal__content">
                        <div class="room-modal__eyebrow">ROOM EXPLORATION</div>
                        <h3 class="room-modal__title" id="roomModalTitle"></h3>

                        <p class="room-modal__desc" id="rmDesc"></p>

                        <div class="room-modal__facts">
                            <div><b>ROOM SIZE</b><div id="rmSize"></div></div>
                            <div><b>OCCUPANCY</b><div id="rmOcc"></div></div>
                            <div><b>BED</b><div id="rmBed"></div></div>
                            <div><b>VIEW</b><div id="rmView"></div></div>
                            <div><b>NIGHTLY</b><div id="rmPrice"></div></div>
                        </div>
                        <div class="room-modal__amenities" id="rmAmenities"></div>


                        <div class="room-modal__actions">
                            <a id="rmCheckBtn" class="room-modal__btn room-modal__btn-primary" href="#">CHECK AVAILABILITY</a>
                            <a id="rmDetailPageBtn" class="room-modal__btn room-modal__btn-outline" href="#">VIEW FULL DETAILS</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <script>
            (function () {
                const modal = document.getElementById('roomModal');
                if (!modal)
                    return;

                const rmImg = document.getElementById('rmImg');
                const title = document.getElementById('roomModalTitle');
                const descEl = document.getElementById('rmDesc');
                const rmSize = document.getElementById('rmSize');
                const rmOcc = document.getElementById('rmOcc');
                const rmBed = document.getElementById('rmBed');
                const rmView = document.getElementById('rmView');
                const rmPrice = document.getElementById('rmPrice');
                const rmCheckBtn = document.getElementById('rmCheckBtn');
                const rmDetailPageBtn = document.getElementById('rmDetailPageBtn');

                // ✅ contextPath của JSP
                const ctx = '<%= request.getContextPath() %>';

                function openModal() {
                    modal.classList.add('open');
                    modal.setAttribute('aria-hidden', 'false');
                    document.body.style.overflow = 'hidden';
                }

                function closeModal() {
                    modal.classList.remove('open');
                    modal.setAttribute('aria-hidden', 'true');
                    document.body.style.overflow = '';
                }

                // ✅ plural helper (JS thuần)
                function plural(n, one, many) {
                    n = Number(n || 0);
                    return n === 1 ? one : many;
                }

                // ✅ CLICK DETAILS (mở modal)
                document.addEventListener('click', function (e) {
                    const btn = e.target.closest('.js-room-detail');
                    if (!btn)
                        return;

                    e.preventDefault();
                    e.stopPropagation();

                    const d = btn.dataset;

                    const id = d.id || '';
                    const name = d.name || 'Room';
                    const imgUrl = d.img || '';
                    const bed = d.bed || 'Bed';
                    const view = d.view || 'View';
                    const size = d.size || 'N/A';

                    const adult = Number(d.adult || 0);
                    const child = (d.child && d.child !== 'null' && d.child !== '') ? Number(d.child || 0) : null;

                    const price = d.price;
                    const desc = d.desc || '';

                    // Fill UI
                    rmImg.src = imgUrl;
                    rmImg.alt = name;
                    title.textContent = name;

                    descEl.textContent = desc
                            ? desc
                            : 'A refined blend of comfort and modern design, curated for a restful stay.';

                    rmSize.textContent = size;
                    rmBed.textContent = bed;
                    rmView.textContent = view;

                    // ✅ AMENITIES
                    const rmAmenities = document.getElementById('rmAmenities');
                    if (rmAmenities) {
                        const raw = (d.amenities || '').trim();
                        const items = raw ? raw.split('|') : [];

                        rmAmenities.innerHTML = items.map(function (x) {
                            return '<div class="room-modal__amenity"><span class="ico">✓</span> ' + x + '</div>';
                        }).join('');
                    }


                    // ✅ OCCUPANCY (KHÔNG dùng template string để tránh JSP parse )
                    let occText = 'Up to ' + adult + ' ' + plural(adult, 'Adult', 'Adults');
                    if (child !== null) {
                        occText += ', ' + child + ' ' + plural(child, 'Child', 'Children');
                    }
                    rmOcc.textContent = occText;

                    // Price
                    rmPrice.textContent = (price && price !== 'null') ? ('$' + price) : 'CONTACT';

                    // Buttons (nối chuỗi để không có  trong JS)
                    rmCheckBtn.href = ctx + '/booking?roomTypeId=' + id;
                    rmDetailPageBtn.href = ctx + '/room-type/detail?id=' + id;

                    openModal();
                });

                // ✅ Close when click backdrop/X
                modal.addEventListener('click', function (e) {
                    if (e.target.closest('[data-close="1"]'))
                        closeModal();
                });

                // ✅ ESC close
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && modal.classList.contains('open'))
                        closeModal();
                });
            })();
        </script>
        <script>
            (function () {
                const header = document.querySelector('.header');
                if (!header)
                    return;

                function onScroll() {
                    header.classList.toggle('is-scrolled', window.scrollY > 8);
                }

                onScroll();
                window.addEventListener('scroll', onScroll, {passive: true});
            })();
        </script>
    </body>
</html>
