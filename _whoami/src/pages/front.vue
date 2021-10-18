<template>
  <div class="main-container" v-show="$parent.loading" style="display: none;">
    <div class="useful-link no-print">
      <a href="/">🚀 返回站点</a>
      <br><br>
      <a href="./resume.pdf" target="_blank">📬 下载简历</a>
    </div>
    <section class="section section-header">
      <div class="section-bg section-header-bg"></div>
      <div class="section-bg section-content-bg"></div>
      <div class="container">
        <header class="header">
          <div class="header-box">
            <div class="avatar wow inShow no-print">
              <img src="../../public/img/logo.jpg" alt="logo" class="img-responsive">
            </div>
          </div>
        </header>
        <div class="section-content">
          <div class="content-box">
            <div class="name-slogan">
              <h1 class="wow inShow no-print" data-wow-delay="0.1s">
                <span class="text-light">{{userInfo.lastName}}</span> {{userInfo.firstName}}
              </h1>
            </div>
            <div class="contact-info">
              <div class="row">
                <div class="col-md-4">
                  <div class="item wow inShow" data-wow-delay="0.3s">
                    <h4>信息</h4>
                    <div class="info">{{userInfo.name}} {{userInfo.sex}} {{calcDate(userInfo.birthday)}}岁</div>
                  </div>
                </div>
                <div class="col-md-4">
                  <a class="item wow inShow" data-wow-delay="0.55s" :href="'//'+userInfo.website" target="_blank">
                    <h4>地址</h4>
                    <div class="info">{{userInfo.location}}</div>
                  </a>
                </div>
                <div class="col-md-4">
                  <div class="item wow inShow" data-wow-delay="0.6s">
                    <h4>学历</h4>
                    <div class="info">{{userInfo.education}}</div>
                  </div>
                </div>
              </div>
              <div class="row">
                <div class="col-md-4">
                  <div class="item wow inShow" data-wow-delay="0.35s">
                    <h4>微信</h4>
                    <div class="info">{{userInfo.wechat}}</div>
                  </div>
                </div>
                <div class="col-md-4">
                  <a class="item wow inShow" data-wow-delay="0.45s" :href="'mailto:'+userInfo.email" target="_blank">
                    <h4>邮箱</h4>
                    <div class="info">{{userInfo.email}}</div>
                  </a>
                </div>
                <div class="col-md-4">
                  <a class="item wow inShow" data-wow-delay="0.65s" :href="'//github.com/'+userInfo.github" target="_blank">
                    <h4>电话</h4>
                    <div class="info">{{userInfo.phone}}</div>
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="section">
      <div class="container">
        <div class="section-bg section-header-bg"></div>
        <div class="section-bg section-content-bg"></div>
        <header class="header">
          <div class="content-box">
            <h2 class="title">介绍 / 
              <small><i>Intro</i></small>
            </h2>
            <div class="description no-print">介绍一些个人基本情况</div>
          </div>
        </header>
        <div class="section-content">
          <div class="intro">
            <p v-for="(intro,idx) in userInfo.intro" :key="idx" v-html="intro"></p>
          </div>
        </div>
      </div>
    </section>
    <section class="section">
      <div class="container">
        <div class="section-bg section-header-bg"></div>
        <div class="section-bg section-content-bg"></div>
        <header class="header">
          <div class="content-box">
            <h2 class="title">获得奖项 / 
              <small><i>Honor</i></small>
            </h2>
            <div class="description no-print">本科时期获得奖项</div>
          </div>
        </header>
        <div class="section-content">
          <div class="row honor">
            <div class="col-md-3 honor-item" v-for="honor in userInfo.honor" :key="honor.img">
              <div class="item">
                <img class="no-print" :src="'./img/honor/'+honor.img+'.jpg'" :alt="honor.img">
                <small>{{honor.time}}</small>
                <small>{{honor.name}}</small>
                <small>{{honor.honor}}</small>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="section">
      <div class="container">
        <div class="section-bg section-header-bg"></div>
        <div class="section-bg section-content-bg"></div>
        <header class="header">
          <div class="content-box">
            <h2 class="title">技能 / 
              <small><i>Skills</i></small>
            </h2>
            <div class="description no-print">自己的技术评价</div>
          </div>
        </header>
        <div class="section-content">
          <div class="skill">
            <div class="skill-item" v-for="skill in userInfo.skill" :key="skill.name">
              <div class="item">
                <div class="text-info">
                  <span class="hide show-print-inline">{{skill.desc}}</span>
                  {{skill.name}}
                </div>
                <div class="progress">
                  <div class="progress-bar wow progressShow" :style="'width:'+skill.percent"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="section page-break-section">
      <div class="container">
        <div class="section-bg section-header-bg"></div>
        <div class="section-bg section-content-bg"></div>
        <header class="header">
          <div class="content-box">
            <h2 class="title">工作经历 /
              <small><i>Work</i></small>
            </h2>
            <div class="description no-print">以往的工作</div>
          </div>
        </header>
        <div class="section-content">
          <div class="experience">
            <div class="item dot" v-for="item in userInfo.job" :key="item.title">
              <div class="row">
                <div class="col-md-3">
                  <div class="time">{{item.time}}</div>
                  <div class="title">{{item.name}}</div>
                  <div>{{item.group}}</div>
                  <div>{{item.company}}</div>
                </div>
                <div class="col-md-9">
                  <div class="content">
                    <p v-for="desc in item.content" :key="desc">{{desc}}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="section">
      <div class="container">
        <div class="section-bg section-header-bg"></div>
        <div class="section-bg section-content-bg"></div>
        <header class="header">
          <div class="content-box">
            <h2 class="title">个人项目 /&nbsp;
              <small><i>Project</i></small>
            </h2>
            <div class="description no-print">做过的一些项目</div>
          </div>
        </header>
        <div class="section-content">
          <div class="experience">
            <div class="item description hide show-print-inline">
              查看在线简历便于访问项目地址:
              <a :href="'//'+userInfo.website+'/whoami'">{{userInfo.website}}/whoami</a>
              <br>
            </div>
            <div class="item dot" v-for="item in userInfo.project" :key="item.title">
              <div class="row">
                <div class="col-md-3">
                  <div class="time">{{item.time}}</div>
                  <div class="title">{{item.title}}</div>
                  <div v-if="item.technology" class="technology">
                    <b>技术栈</b>
                    <ul class="inline">
                      <li v-for="(techItem,techItemIndex) in item.technology" :key="techItemIndex">{{techItem}}</li>
                    </ul>
                  </div>
                </div>
                <div class="col-md-9">
                  <div class="content">
                    {{item.description}}
                    <p class="extra-html" v-if="item.extra" v-html="item.extra"></p>
                  </div>
                  <div v-if="item.content" class="tips">
                    <b>主要工作及项目实现的功能:</b>
                    <ul>
                      <li v-for="list in item.content" :key="list">{{list}}</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="section">
      <div class="container">
        <div class="section-bg section-header-bg"></div>
        <div class="section-bg section-content-bg"></div>
        <header class="header">
          <div class="content-box">
            <h2 class="title">联系&nbsp;/&nbsp;
              <small><i>Contact</i></small>
            </h2>
            <div class="description no-print">通过这些信息可以联系到我</div>
          </div>
        </header>
        <div class="section-content">
          <div class="contact">
            <div class="row">
              <div class="col-md-3">
                <div class="item">
                  <h4>微信 </h4>
                  <span class="info">{{userInfo.wechat}}</span>
                </div>
              </div>
              <div class="col-md-6">
                <a class="item" :href="'mailto:'+userInfo.email" target="_blank">
                  <h4>邮箱 </h4>
                  <span class="info">{{userInfo.email}}</span>
                </a>
              </div>
              <div class="col-md-3">
                <div class="item">
                  <h4>电话 </h4>
                  <span class="info">{{userInfo.phone}}</span>
                </div>
              </div>
            </div>
          </div>
          <div class="name-slogan no-print">
            <h1 class="wow inShow">
              <span class="text-light">{{userInfo.lastName}}</span>&nbsp;{{userInfo.firstName}}
            </h1>
            <div class="description wow inShow" data-wow-delay="0.05s">{{userInfo.slogan}}（{{userInfo.tips}}）</div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
  export default {
    name: 'front',
    data() {
      return {
        userInfo: {
          name:null,
          sex:null,
          birthday:null,
          firstName:null,
          lastName:null,
          slogan:null,
          tips:null,
          education:null,
          phone:null,
          location:null,
          wechat:null,
          website:null,
          github:null,
          email:null,
          intro:[],
          honor:[],
          skill:[],
          job:[],
          project:[]
        }
      }
    },
    created(){
      var self = this;
      this.$http.get('whoami.json').then((res) =>{
        self.userInfo = res.data;
        this.$parent.loading = true;
      });
    },
    methods:{
      calcDate(birthday){
        let birthdayDate = new Date(birthday);
        let todyDate = new Date();
        return todyDate.getYear() - birthdayDate.getYear()
      }
    }
  }
</script>
