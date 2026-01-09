import React, { useEffect, useState } from 'react'
import { Sidebar, List, Detail } from './components'
import { useTaskStore } from './store/useTaskStore'
import './App.css'

function App() {
  const [selectedTask, setSelectedTask] = useState(null)
  const { fetchPriorities } = useTaskStore()

  useEffect(() => {
    fetchPriorities()
  }, [])

  // 全局布局策略：仅在选中任务时显示详情面板，从而驱动列表在未选中时全宽显示
  const showDetail = !!selectedTask

  return (
    <div className="app-container">
      <Sidebar />
      <main className="content-area">
        <List onSelectTask={setSelectedTask} />
        {showDetail && (
          <Detail task={selectedTask} onDelete={() => setSelectedTask(null)} />
        )}
      </main>
    </div>
  )
}

export default App
