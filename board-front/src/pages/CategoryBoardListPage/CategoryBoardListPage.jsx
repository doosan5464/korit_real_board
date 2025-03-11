/**@jsxImportSource @emotion/react */
import { FcLike } from 'react-icons/fc';
import * as s from './style';
import React, { useEffect, useRef } from 'react';
import { GrView } from 'react-icons/gr';

function CategoryBoardListPage(props) {

    const loadMoreRef = useRef(null); // 무한 스크롤을 위한 마지막 요소의 ref 생성

    useEffect(() => { // Intersection Observer 콜백 함수: 요소가 뷰포트에 들어오면 실행
        const observerCallback = (entries) => {
            const [entry] = entries;    // 첫 번째 entry 가져오기
            if (entry.isIntersecting) { // 요소가 화면에 보일 경우
                console.log("다음 페이지 데이터 refetch 해줘");
                // 데이터 재요청 트리거 (API 요청 등)
            }
        }

        const observerOption = {
            threshold: 1.0 // 요소가 100% 화면에 들어왔을 때만 실행
        }

        const observer = new IntersectionObserver(observerCallback, observerOption)
        observer.observe(loadMoreRef.current); // `loadMoreRef`가 가리키는 요소 감시 시작
    }, []);


    return (
        <div css={s.scrollLayout}> {/* 스크롤 가능한 레이아웃 적용 */}
            <div css={s.cardLayoutGroup}>
                <div css={s.cardLayout}>
                    <header>
                        <div css={s.headerLeft}>
                            <div css={s.profileImgBox}>
                                <img src="" alt="" />
                            </div>
                            <span>nickname</span>
                        </div>
                        <div css={s.boardCounts}>
                            {/* 조회수 */}
                            <span>
                                <GrView />
                                <span>{200}</span>
                            </span>
                            {/* 좋아요 수 */}
                            <span>
                                <FcLike />
                                <span>{100}</span>
                            </span>
                        </div>
                    </header>
                    <main>
                        <h2 css={s.boardTitle}>게시글 제목입니다.</h2>
                    </main>
                </div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
                <div css={s.cardLayout}></div>
            </div>

            <div ref={loadMoreRef}></div> {/* 무한 스크롤 감지를 위한 빈 div */}
        </div>
    );
}

export default CategoryBoardListPage;