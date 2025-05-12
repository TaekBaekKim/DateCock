<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="notop" value="true" />
<c:set var="nofooter" value="true" />


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>ServeMain</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&display=swap" rel="stylesheet">

    <style>
        html, body {
            height: 100%;
            margin: 0;
            font-family: 'Gowun Dodum', sans-serif;
            background-image: linear-gradient(to top, #d9afd9 0%, #97d9e1 100%);
            background-repeat: no-repeat;
            background-size: cover;
            background-attachment: fixed;
        }

        .carousel-container {
            position: relative;
            height: 100vh;
            overflow: hidden;
        }

        .carousel-inner,
        .carousel,
        .carousel .item {
            height: 100vh;
        }

        .fill {
            width: 100%;
            height: 100vh;
            background-size: cover;
            background-position: center;
        }

        .carousel-indicators {
            display: none;
        }

        .userEL18853582-bg1 { background-image: url('./image/서브메인1.png'); }
        .userEL18853582-bg2 { background-image: url('./image/서브메인2.jpg'); }
        .userEL18853582-bg3 { background-image: url('./image/서브메인3.png'); }
        .userEL18853582-bg4 { background-image: url('./image/서브메인4.png'); }
        .userEL18853582-bg5 { background-image: url('./image/서브메인5.jpg'); }
        .userEL18853582-bg6 { background-image: url('./image/서브메인6.png'); }
        .userEL18853582-bg7 { background-image: url('./image/서브메인7.png'); }

        .bg-box {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #000;
            opacity: 0.3;
        }

        .center-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            z-index: 10;
        }

        .description {
            font-size: 70px;
            font-weight: 800;
            color: #ff4f9a;
            text-shadow: 2px 2px 6px rgba(0, 0, 0, 0.2);
            letter-spacing: 2px;
            margin-bottom: 30px;
        }

        .btn {
            border: none;
            cursor: pointer;
            text-transform: uppercase;
            color: #fff;
            font-weight: 700;
            font-size: 20px;
            background-color: #ff4f9a;
            padding: 22px 80px;
            border-radius: 50px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
            transition: background 0.3s ease;
        }

        .btn:hover {
            background-color: #e64589;
        }
    </style>
</head>
<body>

<div id="userEL18853582-carousel" class="carousel slide carousel-container">
    <div class="carousel-inner">

        <!-- 슬라이드 1 -->
        <div class="item active">
            <div class="fill userEL18853582-bg1"></div>
            <div class="bg-box"></div>
            <div class="center-content">
                <p class="description">DateCock</p>
                <button class="btn" onclick="location.href='main'"><span>Home</span></button>
                
            </div>
        </div>

        <!-- 슬라이드 2 -->
        <div class="item">
            <div class="fill userEL18853582-bg2"></div>
            <div class="bg-box"></div>
            <div class="center-content">
                <p class="description">DateCock</p>
                <button class="btn" onclick="location.href='main'"><span>Home</span></button>
            </div>
        </div>

        <!-- 슬라이드 3 -->
        <div class="item">
            <div class="fill userEL18853582-bg3"></div>
            <div class="bg-box"></div>
            <div class="center-content">
                <p class="description">DateCock</p>
                <button class="btn" onclick="location.href='main'"><span>Home</span></button>
            </div>
        </div>
        <!-- 슬라이드 4 -->
        <div class="item">
            <div class="fill userEL18853582-bg4"></div>
            <div class="bg-box"></div>
            <div class="center-content">
                <p class="description">DateCock</p>
                <button class="btn" onclick="location.href='main'"><span>Home</span></button>
            </div>
        </div>
        <!-- 슬라이드 5 -->
        <div class="item">
            <div class="fill userEL18853582-bg5"></div>
            <div class="bg-box"></div>
            <div class="center-content">
                <p class="description">DateCock</p>
                <button class="btn" onclick="location.href='main'"><span>Home</span></button>
            </div>
        </div>
        <!-- 슬라이드 6 -->
        <div class="item">
            <div class="fill userEL18853582-bg6"></div>
            <div class="bg-box"></div>
            <div class="center-content">
                <p class="description">DateCock</p>
                <button class="btn" onclick="location.href='main'"><span>Home</span></button>
            </div>
        </div>
        <!-- 슬라이드 7 -->
        <div class="item">
            <div class="fill userEL18853582-bg7"></div>
            <div class="bg-box"></div>
            <div class="center-content">
                <p class="description">DateCock</p>
                <button class="btn" onclick="location.href='main'"><span>Home</span></button>
            </div>
        </div>
    </div>

    <!-- 슬라이드 컨트롤 -->
    <a class="left carousel-control" href="#userEL18853582-carousel" data-slide="prev">
        <span class="glyphicon glyphicon-chevron-left"></span>
    </a>
    <a class="right carousel-control" href="#userEL18853582-carousel" data-slide="next">
        <span class="glyphicon glyphicon-chevron-right"></span>
    </a>
</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script>
    $(document).ready(function () {
        $('#userEL18853582-carousel').carousel({
            interval: 3000,
            ride: 'carousel',
            pause: false 
        });
    });
</script>

</body>
</html>
