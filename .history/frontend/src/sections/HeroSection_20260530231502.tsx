import { useState, useEffect } from 'react'
import { Link } from 'react-router'
import { MONO, BODY } from '../utils/fonts'
import { api, type ApiSystemAnnouncement } from '../lib/api'

const TYPE_LEVEL_MAP: Record<string, { level: string; color: string }> = {
  info: { level: 'INFO', color: '#888888' },
  warn: { level: 'WARN', color: '#e60012' },
  alert: { level: 'NEW', color: '#e60012' },
  maintenance: { level: 'WARN', color: '#e60012' },
}

export default function HeroSection() {
  const [announcements, setAnnouncements] = useState<ApiSystemAnnouncement[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.announcements.list()
      .then((data) => setAnnouncements(Array.isArray(data) ? data : []))
      .catch(() => setAnnouncements([]))
      .finally(() => setLoading(false))
  }, [])

  return (
    <>
      <style>{`
        @keyframes marquee {
          0% { transform: translateX(0); }
          100% { transform: translateX(-50%); }
        }
        .marquee-track { animation: marquee 40s linear infinite; }
      `}</style>

      <section id="hero" className="relative min-h-[calc(100dvh-96px)] overflow-hidden">
        {/* Background Video */}
        <video
          autoPlay muted loop playsInline
          className="absolute inset-0 w-full h-full object-cover"
          style={{ filter: 'brightness(0.3)' }}
        >
          <source src="/assets/hero-abyss.mp4" type="video/mp4" />
        </video>

        {/* Dark gradient overlays */}
        <div className="absolute inset-0 bg-gradient-to-t from-[#0a0a0a] via-[#0a0a0a]/20 to-[#0a0a0a]/60" />
        <div className="absolute inset-0 bg-gradient-to-r from-[#0a0a0a]/70 via-transparent to-[#0a0a0a]/80" />

        {/* 装饰性光晕 */}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-red-900/8 rounded-full blur-[150px] pointer-events-none" />

        {/* ===== Top Info Bar ===== */}
        <div className="absolute top-0 left-0 right-0 z-20 px-6 py-4">
          <div className="max-w-[720px] mx-auto flex items-center justify-between" style={{ fontFamily: MONO }}>
            <div className="flex items-center gap-3 text-[10px] tracking-[0.2em] uppercase text-[#888888]">
              <span className="w-6 h-[1px] bg-[#d4a373]/50" />
              <span className="text-[#d4a373]">THE MARGINAL STRUCTURE</span>
            </div>
            <div className="text-[10px] tracking-[0.2em] uppercase text-[#888888]">
              <span>EST. [DATA REDACTED]</span>
            </div>
          </div>
        </div>

        {/* 背景Logo水印 */}
        <div className="absolute inset-0 z-[5] flex items-center justify-center pointer-events-none select-none">
          <img src="/assets/TheMarginalStructure-Logo.png" alt=""
            className="w-[280px] md:w-[600px] opacity-[0.06] md:opacity-[0.08]" />
        </div>
        {/* ===== Main Content (Centered) ===== */}
        <div className="relative z-10 min-h-[calc(100dvh-96px)] flex items-center justify-center px-6 py-24">
          <div className="w-full max-w-[720px] text-center">

            {/* Status Badge */}
            <div className="mb-8 flex justify-center">
              <div
                className="inline-flex items-center gap-2 px-3 py-1.5 border border-[#e60012]/40 text-[#e60012] text-[10px] tracking-widest"
                style={{ fontFamily: MONO }}
              >
                <span className="w-1.5 h-1.5 rounded-full bg-[#e60012] animate-pulse" />
                SIGNAL ACTIVE / 当前阈界信号在线
              </div>
            </div>

            {/* Main Title */}
            <h1
              className="text-[clamp(2.8rem,7vw,5.5rem)] text-[#f0f0f0] font-black leading-[1.05] tracking-[0.04em] mb-3 relative z-10"
              style={{ fontFamily: BODY }}
            >
              边际结构
            </h1>
            <div className="text-sm md:text-base text-[#888888] tracking-[0.3em] uppercase mb-8" style={{ fontFamily: MONO }}>
              THE MARGINAL STRUCTURE
            </div>

            {/* Description */}
            <p className="text-sm md:text-base text-[#a0a0a0] leading-relaxed mb-6">
              一个致力于管理<span className="text-[#d4a373] font-medium">阈界异常现象</span>的国际秘密组织。
            </p>

            {/* Motto */}
            <p className="text-lg md:text-xl text-[#d4d4d4] font-medium tracking-wide leading-relaxed mb-2">
              测绘黑暗，设立路标，<span className="text-white font-semibold">而非征服</span>
            </p>
            <p className="text-[10px] md:text-[11px] text-[#888888]/40 tracking-[0.25em] mb-10 uppercase" style={{ fontFamily: MONO }}>
              MAP THE DARKNESS · SET THE GUIDEPOSTS · NEVER CONQUER
            </p>

            {/* CTA Buttons */}
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link
                to="/archives"
                className="group inline-flex items-center gap-2 bg-gradient-to-br from-[#e60012] to-[#b8000e] text-white px-8 py-3.5 text-sm font-medium rounded-sm transition-all duration-300 hover:-translate-y-0.5 hover:shadow-[0_8px_30px_-8px_rgba(230,0,18,0.5)]"
                data-cursor-hover
              >
                访问档案库
                <svg className="w-4 h-4 transition-transform group-hover:translate-x-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M5 12h14M12 5l7 7-7 7" />
                </svg>
              </Link>
              <Link
                to="/operations"
                className="group inline-flex items-center gap-2 border border-white/20 text-[#f0f0f0] px-8 py-3.5 text-sm rounded-sm transition-all duration-300 hover:border-[#d4a373]/60 hover:bg-[#d4a373]/5 hover:text-[#d4a373] hover:-translate-y-0.5"
                data-cursor-hover
              >
                查看行动计划
                <svg className="w-4 h-4 transition-transform group-hover:translate-x-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M5 12h14M12 5l7 7-7 7" />
                </svg>
              </Link>
            </div>

          </div>
        </div>

        {/* ===== Bottom Info Bar ===== */}
        <div className="absolute bottom-0 left-0 right-0 z-20" style={{ background: 'rgba(0,0,0,0.6)', backdropFilter: 'blur(10px)', borderTop: '1px solid rgba(255,255,255,0.05)' }}>
          <div className="w-full mx-auto px-6 py-3 flex items-center justify-between gap-4">
            {/* Left: Signal Status */}
            <div className="flex items-center gap-3 text-[10px] font-mono flex-shrink-0">
              <div className="flex items-center gap-2 px-2.5 py-1 border border-red-900/30 rounded" style={{ background: 'rgba(127, 23, 23, 0.15)' }}>
                <span className="w-1.5 h-1.5 bg-red-500 rounded-full animate-pulse" />
                <span className="text-red-400 tracking-wider">SIGNAL ACTIVE</span>
              </div>
            </div>

            {/* Center: Marquee */}
            <div className="flex-1 min-w-0 overflow-hidden" style={{ maskImage: 'linear-gradient(to right, transparent, black 5%, black 95%, transparent)' }}>
              <div className="marquee-track flex gap-12 text-[10px] font-mono text-gray-500 whitespace-nowrap w-max">
                {[...announcements, ...announcements].map((a, i) => {
                  if (!a) return null
                  const typeInfo = TYPE_LEVEL_MAP[a.type] || TYPE_LEVEL_MAP.info
                  return (
                    <span key={i} className="flex items-center gap-2">
                      <span className="px-1 py-0.5 text-[8px] leading-none rounded" style={{ color: typeInfo.color, background: `${typeInfo.color}15`, border: `1px solid ${typeInfo.color}30` }}>
                        {typeInfo.level}
                      </span>
                      <span>{new Date(a.createdAt).toLocaleDateString('zh-CN').replace(/\//g, '.')} {a.title}</span>
                    </span>
                  )
                })}
              </div>
            </div>

            {/* Right: Version */}
            <div className="flex items-center gap-3 text-[10px] font-mono text-gray-600 flex-shrink-0">
              <span className="w-1.5 h-1.5 bg-green-500/50 rounded-full" />
              <span className="tracking-wider">v2026.5.6</span>
            </div>
          </div>
        </div>
      </section>
    </>
  )
}
